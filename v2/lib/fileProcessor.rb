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
	attr_accessor :lines;

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
		@lines = cnts.length();
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
		p = Regexp.new('\*\*(\w+)\*\*');
		mark = '';
		return mark if @currentLine >= @rawContents.length();
		while (!got)
			md = p.match(@rawContents[@currentLine]);
			if md
				got = true;
				mark = md[1];
			end
			@currentLine+=1;
			return mark if @currentLine >= @rawContents.length();
		end
		return mark;
	end

	def getline ln ##{{{
		return @rawContents[ln];
	end #}}}

	def extractOnelineMarkInfo rawline=-1
		ptrn = Regexp.new('\*\*\w+\*\* +`*([^`]+)`*');
		rawline = @currentLine-1 if (rawline==-1);
		md = ptrn.match(getline(rawline));
		if md
			return md[1];
		else
			return '';
		end
	end
	"""
	extractMultlineMarkInfo: to get a code block for specific mark, this API doesn't need
	to know the exact mark, just get the code block between ``` ```, and won't change the
	current line 'cause the getNextMark API will change it.
	"""
	def extractMultlineMarkInfo ##{{{
		cnts = [];
		ptrn = Regexp.new('```\w*');
		md = nil;
		lindex = 0;
		return cnts if __notACodeBlock__(@currentLine);
		while (md==nil) ##{
			nline = lindex + @currentLine;
			md = ptrn.match(getline(nline));
			lindex+=1;
		end ##}
		## start extracting contents until next ```
		ptrn = Regexp.new('```');
		md = nil;
		while (md==nil) ##{
			nline = lindex+@currentLine;
			md = ptrn.match(getline(nline));
			cnts << getline(nline) if md==nil;
			lindex+=1;
		end ##}
		return cnts;
	end ##}}}

	def __notACodeBlock__ ln ##{{{
		return false if (/```\w*/.match(getline(ln)));
		return true;
	end ##}}}
end ##}