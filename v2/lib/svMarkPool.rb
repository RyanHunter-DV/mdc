"""
This is a markpool ruby class, that collects available marks from a mark file.
and provides APIs for caller to check the mark types
"""

class SVMarkPool ##{
	attr :fp;
	attr :currentClassMark;
	attr :currentMethodMark;
	attr :currentPkgMark;
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
		@methodmarks = ['task','func','vtask','vfunc','ltask','lfunc','sfunc','stask'];
		@methodmarks.push(*@builtinMethods);
		@fieldmarks = ['field'];
		@tlmmarks  = ['tlm-ap','tlm-ai','tlm-ae'];
		@uvmmarks = ['transaction','object','sequence','component','driver','agent','monitor','env','test','sequencer'];
		@classmarks = ['class','interface'];
		@classmarks.push(*@uvmmarks);
	end ##}}}

	def __loadAllSVMarks__ ##{{{
		mark = '<init>'; ## init
		## loop until get an empty mark.
		while (mark != '')
			mark = @fp.getNextMark;
			mk = __processMark__(mark);
			@marks << mk if mk[:type]!=:unknow;
			@currentClassMark = mk if (mk[:type]==:svclass);
			@currentPkgMark   = mk if (mk[:type]==:package);
			@currentMethodMark= mk if (mk[:type]==:method);
		end
	end ##}}}
	
	def __processMark__ mark ##{{{
		mk = {};
		mk[:mark] = mark;
		mk[:type] = __getMarkType__(mark);

		if (mk[:type]==:package)
			mk[:name] = @fp.extractOnelineMarkInfo;
			mk[:body] = [];
			mk[:head] = [];
			return mk;
		end
		if (mk[:type]==:include)
			b = @fp.extractMultlineMarkInfo;
			@currentPkgMark[:body] << 'include '+b.join(";");
			return mk;
		end
		if (mk[:type]==:import)
			b = @fp.extractMultlineMarkInfo;
			@currentPkgMark[:body] << 'import '+b.join(";");
			return mk;
		end
		if (mk[:type]==:head)
			b = @fp.extractMultlineMarkInfo;
			@currentPkgMark[:head] << 'include '+b.join(";");
			return mk;
		end
		if (mk[:type] == :svclass)
			mk[:uvmtype] = '';
			mk[:uvmtype] = mk[:mark] if (@uvmmarks.include?(mk[:mark]));
			mk[:uvmtype] = 'sequence_item' if mk[:uvmtype]=='transaction';
			mk[:name] = @fp.extractOnelineMarkInfo;
			return mk;
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
			if (@builtinMethods.include?(mk[:mark]))
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
			return mk;
		end
		if (mk[:type]==:tlm)
			mk[:proto] = @fp.extractOnelineMarkInfo;
			procs = @fp.extractMultlineMarkInfo;
			mk[:proc] = procs if (not procs.empty?);
			return mk;
		end
		if (mk[:type]==:field)
			mk[:fields] = @fp.extractMultlineMarkInfo;
			return mk;
		end
		if (mk[:type]==:fieldut)
			mk[:fieldut] = @fp.extractMultlineMarkInfo;
			return mk;
		end
		return mk;
	end ##}}}
	def __getMarkType__ mark ##{{{
		return :svclass if @classmarks.include?(mark);
		return :field   if @fieldmarks.include?(mark);
		return :method  if @methodmarks.include?(mark);
		return :tlm     if @tlmmarks.include?(mark);
		return :package if mark=='package';
		return :include if mark=='include';
		return :import  if mark=='import';
		return :head    if mark=='head';
		return :fieldut if mark=='fieldutils';
		return :unknow;
	end ##}}}
end ##}
