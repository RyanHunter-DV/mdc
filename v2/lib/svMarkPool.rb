"""
This is a markpool ruby class, that collects available marks from a mark file.
and provides APIs for caller to check the mark types
"""
class SVMarkPool ##{
	attr :fp;
	attr :currentClassMark;
	attr :currentMethodMark;
	attr :methodmarks;
	attr :builtinMethods;
	attr :fieldmarks;
	attr :tlmmarks;
	attr :classmarks;
	attr :uvmmarks;
	attr_accessor :marks;

	def initialize _fp ##{{{
		@fp    = _fp;
		@marks = [];
		@currentClassMark = nil;
		__initDefaultMarks__;
		__loadAllSVMarks__;
	end ##}}}

	def __initDefaultMarks__ ##{{{
		@builtinMethods = ['new','build','connect','run'];
		@methodmarks = ['task','func','vtask','vfunc','ltask','lfunc'];
		@methodmarks.push(*@builtinMethods);
		@fieldmarks = ['field'];
		@tlmmarks  = ['tlm-ap','tlm-ai','tlm-ae'];
		@uvmmarks = ['transaction','object','sequence','component','driver','agent','monitor','env','test','sequencer'];
		@classmarks = ['class'];
		@classmarks.push(*@uvmmarks);
	end ##}}}

	def __loadAllSVMarks__ ##{{{
		mark = '<init>'; ## init
		## loop until get an empty mark.
		while (mark != '')
			mark = @fp.getNextMark;
			mk = __processMark__(mark);
			@marks << mk;
			@currentClassMark = mk if (mk[:type]==:svclass);
			@currentMethodMark= mk if (mk[:type]==:method);
		end
	end ##}}}
	
	def __processMark__ mark ##{{{
		mk = {};
		mk[:mark] = mark;
		mk[:type] = __getMarkType__(mark);
		if (mk[:type] == :svclass)
			mk[:uvmtype] = '';
			mk[:uvmtype] = mk[:mark] if (@uvmmarks.exists?(mk[:mark]));
		end
		if (mk[:mark] == 'tparam')
			@currentClassMark[:tparam] = @fp.extractOnelineMarkInfo;
		end
		if (mk[:mark] == 'param')
			@currentClassMark[:param] = @fp.extractOnelineMarkInfo;
		end
		if (mk[:mark] == 'base')
			@currentClassMark[:base] = @fp.extractOnelineMarkInfo;
		end

		## process methods/builtin marks
		if (mk[:type]== :method)
			if (@builtinMethods.exists?(mk[:mark]))
				body = @fp.extractMultlineMarkInfo;
				mk[:proc] = body if (not body.empty?);
				return mk;
			end
			p = @fp.extractOnelineMarkInfo;
			p = @fp.extractMultlineMarkInfo if (p=='');
			mk[:proto] = p;
			return mk;
		end
		if (mk[:mark]=='proc')
			@currentMethodMark[:proc] = @fp.extractMultlineMarkInfo;
		end
		return mk;
	end ##}}}
	def __getMarkType__ mark ##{{{
		return :svclass if @classmarks.exists?(mark);
		return :field   if @fieldmarks.exists?(mark);
		return :method  if @methodmarks.exists?(mark);
		return :tlm     if @tlmmarks.exists?(mark);
		return :unknow;
	end ##}}}
end ##}