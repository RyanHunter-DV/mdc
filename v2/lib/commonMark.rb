class CommonMark ##{
	attr :supportiveMarks;

	def initialize
		@supportiveMarks = {};
	end
	
	def loadSupportiveMarks n,mks ##{{{
		@supportiveMarks[n.to_sym] = mks;
		self.define_singleton_method (n+'Marks').to_sym do
			return @supportiveMarks[n.to_sym];
		end
	end ##}}}

	def extractOnelineMarkInfo rawline
		ptrn = RegExp.new('\*\*\w+\*\* +`*(.+)`*');
		md = ptrn.match(rawline);
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
	def extractMultlineMarkInfo fp ##{{{
		cnts = [];
		ptrn = RegExp.new('```\w*');
		md = nil;
		lindex = 0;
		while (md==nil) ##{
			nline = lindex + fp.currentLine;
			md = ptrn.match(fp.getline(nline));
			lindex++;
		end ##}
		## start extracting contents until next ```
		ptrn = RegExp.new('```');
		md = nil;
		while (md==nil) ##{
			nline = lindex+fp.currentLine;
			md = ptrn.match(fp.getline(nline));
			cnts << fp.getline(nline) if md==nil;
			lindex++;
		end ##}
		return cnts;
	end ##}}}


end ##}