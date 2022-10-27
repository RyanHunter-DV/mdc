class FileProcessor ##{
	"""
	This class will provide a bunch of APIs to process the read file contents
	more easily, by the way, it provides some of APIs to detect some of the
	common marks of the input source file, such as the mark of target
	code type is SV or CPP.
	"""
	attr :source;
	attr :currentColumn;
	attr :rawContents;
	attr_accessor :currentLine;

	def initialize fn ##{{{
		@source = fn;
		@currentLine    = 0;
		@currentColoumn = 0;
		@rawContents    = [];
		__readRawContents;
	end ##}}}

	def __readRawContents ##{{{
		fh = File.open(@source,"r");
		cnts = fh.readlines();
		recordStart = false;
		cnts.each do |l|
			l.chomp!;
			@rawContents << l if recordStart;
			recordStart = true if (l == '# Source Code');
		end
	end ##}}}

	"""
	codeType: API to return the target code type this input source file
	want to generate.
	"""
	def codeType ##{{{
		return :SV; ## TODO, this is palceholder only
	end ##}}}

	"""
	getNextMark: an API to get common marks in the source md file, all available mark
	will be quoted by '**', like: **task**
	Attention, this API will directly go through from currentLine until get the next mark,
	all other information will be skipped unless API users explicitly extracted it.
	"""
	def getNextMark
		got = false;
		p = RegExp.new('\*\*(\w+)\*\*');
		mark = '';
		return mark if @currentLine >= @rawContents.len();
		while (!got)
			md = p.match(@rawContents[@currentLine]);
			if md
				got = true;
				mark = md[1];
			end
			@currentLine++;
		end
		return mark;
	end

	def getline ln ##{{{
		return @rawContents[ln];
	end #}}}
end ##}