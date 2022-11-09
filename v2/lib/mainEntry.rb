rhload 'lib/toolOptions' ## loading option processor for this tool
rhload 'lib/fileProcessor' ## loading basic file processor
rhload 'lib/svSupport' ## loading support for SV language
rhload 'lib/cppSupport' ## TODO, tmp not available now
rhload 'lib/generator'



class MainEntry ##{
	attr_accessor :options;
	def initialize
		## load option processor
		@options = ToolOptions.new();
		##
	end

	def run
		sig = 0;
		return 0 if @options.isHelpMode;

		## 1.get source file contents
		fp = FileProcessor.new(@options.source);
		db = nil;
		if fp.codeType == :SV
			## 2.if SV file, then load sv processor
			db = SVSupport.new(fp);
		else
			db = CPPSupport.new(fp);
		end
		## 3.process source file, store information into db
		db.processSource();
		
		smb = SmartBuilder.new(db);
		smb.optimizeDataBase();
		## 4.generate target file.
		gen = Generator.new(db);
		gen.publish();

		return sig;
	end

end ##}