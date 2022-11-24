rhload "#{$TOOLHOME}/../v2/lib/fileProcessor.rb"
rhload "#{$TOOLHOME}/../v2/lib/toolOptions.rb"
class MainEntry ##{

	attr :options;
	attr :marks;

	def initialize
		@marks = [];
		@options = ToolOptions.new();
	end

	def __allocateFilesToBeProcessed__ p ##{
		files = [];
		return [] if p=='';
		## 1. search all available files
		## 2. return files to caller
		cmd = "find #{p} -name \"src-*.md\"";
		files = `#{cmd}`;
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
	def __changeSrcFileNameToTarget__ fn ##{{{
		md = /src-(.*)\.md/.match(fn);
		return fn if not md;
		return md[1];
	end ##}}}
	def __buildtarget__ sroot,sfile,troot ##{{{
		## 1.replace the sfile to target file: tfile
		tdir = File.dirname(sfile);
		tfile= File.basename(sfile);
		tdir.sub!(/#{sroot}/,troot);
		tfile = __changeSrcFileNameToTarget__(tfile);
		tfile = File.join(tdir,tfile);
		## inject breakpoint for test
		puts "tfile: #{tfile}";
		cnts = [];
		heads = []; bodies = [];
		@marks.each do |mk|
			heads.push(*mk[:code]) if mk[:type]==:head;
			bodies.push(*mk[:code]) if mk[:type]==:body;
		end
		cnts.push(*heads);
		bodies.each do |bline|
			cnts << "\t"+bline;
		end
		cnts << "end ##}"; ## add one end line at eof
		fh = File.open(tfile,"w");
		cnts.each do |l|
			fh.write(l+"\n");
		end
		return;
	end ##}}}

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
end ##}