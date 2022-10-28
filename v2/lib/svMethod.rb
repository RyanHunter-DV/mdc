class SVMethod < CommonMark ##{
	@@staticSupportiveMarks = [
		'task','stask','vtask','ltask','lvtask',
		'func','sfunc','vfunc','lfunc','lvfunc',
		'new','build','connect','run'
	];
	@@builtins = ['new','build','connect','run'];
	def self.marks; return @@staticSupportiveMarks; end

	attr_accessor :container;
	attr_accessor :type;
	
	attr :mark;
	attr :qualifiers; ## [] stored kind of local/virtual ...
	attr_accessor :prototype;
	attr_accessor :procedures;

	def initialize mk,cls ##{{{
		@mark = mk.to_s;
		@container = cls;
		@prototype = [];
		@procedures = [];
		__setupType__;
		__extractQualifiersFromMark__;
		__setupBuiltins__ if @@builtins.include?(mk);
	end ##}}}
	def __setType__ ##{{{
		ptrn = RegExp.new('\w*task');
		if (ptrn.match(@mark))
			@type = :task;
		else
			@type = :func;
		end
	end ##}}}

	def __setupBuiltins__ ##{{{
		@qualifiers << 'virtual' unless @mark=='new';
		@prototype << 'function' if @mark=='new';
		@prototype << 'function void' if @mark=='build' or @mark=='connect';
		@prototype << 'task' if @mark=='run';
		if (@mark=='new')
			## for new
			proto = 'new (string name="'+@container.name+'"';
			proto += ',uvm_component parent=null' if @container.isComponent;
			proto += ');';
			@prototype << proto;
			body = 'super.new(name';
			body += ',parent' if @container.isComponent;
			body += ');';
			@procedures << body;
		else
			@prototype << @mark.to_s+'_phase(uvm_phase phase)';
			@procedures << 'super.'+@mark.to_s+'_phase(phase);';
		end
		return;
	end ##}}}

	def isBuiltin ##{{{
		return @@builtins.include?(@mark);
	end ##}}}
	def __extractQualifiersFromMark__ ##{{{
		@qualifiers=[];
		@qualifiers<<'virtual' if @mark[0]=='v';
		@qualifiers<<'static'  if @mark[0]=='s';
		@qualifiers<<'local'   if @mark[0]=='l';
		@qualifiers<<'virtual' if @mark[1]=='v';
		@qualifiers<<'static'  if @mark[1]=='s';
		@qualifiers<<'local'   if @mark[1]=='l';
	end ##}}}

	def __splitMethodHeader p ##{{{
		if @type == :task
			@prototype << 'task';
			@prototype << p;
			return;
		end
		ptrn = RegExp.new('(\S+) +(\S+)');
		md = ptrn.match(p);
		if md
			@prototype << 'function '+md(1);
			@prototype << md(2);
		else
			puts "*E, invalid function prototype specified, should be <return> <identifier> ...";
		end
		return;
	end ##}}}
	def extractPrototype fp ##{{{
		linenum = fp.currentLine-1;
		proto = extractOnelineMarkInfo(fp.getline(linenum));
		proto = extractMultlineMarkInfo(fp) if proto=='';
		if proto.is_a?(String)
			__splitMethodHeader(proto);
		else
			__splitMethodHeader(proto[0]);
		end
	end ##}}}
	def extractProcedures fp ##{{{
		mark = fp.getNextMark;
		if mark != 'proc'
			puts "*E, a proc must exists after a method prototype";
			return;
		end
		@procedures.append(*extractMultlineMarkInfo(fp));
	end ##}}}
	def setupTLM tlm,fp ##{{{
		@prototype << 'function void';
		@prototype << 'write_'+tlm.suffix+'('+tlm.trans+' _tr)';
		@procedures.append(*extractMultlineMarkInfo(fp));
		return;
	end ##}}}
end ##}