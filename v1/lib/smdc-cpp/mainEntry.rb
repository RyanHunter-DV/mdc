rhload "#{$TOOLHOME}/../v2/lib/fileProcessor.rb"
rhload "#{$TOOLHOME}/../v2/lib/toolOptions.rb"
class MainEntry ##{
	attr :options;
	attr :marks;
	def initialize
		@marks = [];
		@options = ToolOptions.new();
	end
	def run
		srcFiles = __allocateFilesToBeProcessed__(@options.sourcePath);
		srcFiles.each do |f|
			fp = FileProcessor.new(f);
			@marks=[]; ## initialize
			__loadAllMarks__(fp);
			__buildtarget__(@options.sourcePath,f,@options.targetPath);
		end
		return 0;
	end
	def __allocateFilesToBeProcessed__ p ##{
		files = [];
		return [] if p=='';
		## 1. search all available files
		## 2. return files to caller
		cmd = "find #{p} -name \"src-*.md\"";
		files = `#{cmd}`.split("\n");
		if files.empty?
			puts "Error, nothing found by specified path(#{p})";
			exit 1
		end
		return files;
	end ##}
	def __loadAllMarks__ fp ##{{{
		mark = '<init>'; ## init
		## loop until get an empty mark.
		while (mark != '')
			mark = fp.getNextMark;
			mk = __processMark__(mark,fp);
			@marks << mk if mk[:type]!=:unknow;
		end
	end ##}}}
	
	def __processMark__  mark,fp ##{{{
		mk = {};
		## only 2 marks for smdc-rb
		## :head, :body
		mk[:mark] = mark;
		mk[:type] = mark.to_sym;
		mk[:code] = fp.extractMultlineMarkInfo;
		return mk;
	end ##}}}
	def __generateDirRecursively__ full ##{{{
		toCreate = [];
		p = File.dirname(full);
		existed = false;
		while (existed==false) do
			if (Dir.exists?(p))
				existed = true;
				break;
			end
			toCreate << p;
			p = File.dirname(p);
		end
		toCreate.reverse.each do |np|
			puts "creating dir: #{np}";
			Dir.mkdir np;
		end
		return;
	end ##}}}
	def __buildtarget__ sroot,sfile,troot ##{{{
		## 1.replace the sfile to target file: tfile
		tdir = File.dirname(sfile);
		tfile= File.basename(sfile);
		sroot.sub!(/\/ *$/,'');
		ptrn = Regexp.new("#{sroot}");
		tdir.sub!(ptrn,troot);
		tfile = __changeSrcFileNameToTarget__(tfile);
		tfile = File.join(tdir,tfile);
		__generateDirRecursively__(tfile);
		## inject breakpoint for test
		puts "generating: #{tfile}";
		cnts = [];
		heads = []; bodies = [];
		@marks.each do |mk|
			heads.push(*mk[:code]) if mk[:type]==:head;
			bodies.push(*mk[:code]) if mk[:type]==:body;
		end
		cnts<<"#ifndef #{tfile}__h";
		cnts<<"#define #{tfile}__h";
		cnts.push(*heads);
		cnts<<"#endif";
		fh = File.open(tfile+'.h',"w");
		cnts.each do |l|
			fh.write(l+"\n");
		end
		fh.close;
		cnts = []; ## clear content
		cnts<<"#ifndef #{tfile}__cpp";
		cnts<<"#define #{tfile}__cpp\n";
		cnts<<"#include <#{tfile}.h>\n";
		cnts.push(*bodies);
		cnts<<"#endif";
		fh = File.open(tfile+".cpp","w");
		cnts.each do |l|
			fh.write(l+"\n");
		end
		fh.close;
		return;
	end ##}}}
	def __changeSrcFileNameToTarget__ fn ##{{{
		md = /src-(.*)\.md/.match(fn);
		return fn if not md;
		return md[1];
	end ##}}}
end ##}
