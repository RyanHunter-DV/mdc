rhload 'lib/toolOptions.rb' ## loading option processor for this tool
rhload 'lib/fileProcessor.rb' ## loading basic file processor
rhload 'lib/svSupport.rb' ## loading support for SV language
rhload 'lib/cppSupport.rb' ## TODO, tmp not available now
rhload 'lib/smartBuilder.rb'
rhload 'lib/generator.rb'



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
			db = SVSupport.new(fp,:SV);
		else
			db = CPPSupport.new(fp,:CPP);
		end
		## 3.process source file, store information into db
		db.processSource();
		smb = SmartBuilder.new(db);
		smb.optimizeDataBase();
		## 4.generate target file.
		gen = Generator.new(db,@options.source);
		gen.publish();

		return sig;
	end

end ##}