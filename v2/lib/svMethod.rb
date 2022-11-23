class SVMethod ##{
	attr :prototype;
	attr :body;
	attr :container;
	attr :qualifiers; ## virtual, static ...
	attr :type; ## task or func
	attr :returnType;
	attr :builtinMarks;
	attr_accessor :name;
	attr :noReturnType;

	def initialize p='',cls=nil,mk='func' ##{{{
		@container = cls;
		@noReturnType = false;
		@body = [];
		__initBuiltinMarks__;
		if __isBuiltIns__(mk)
			p = createProtoAndBodyForBuiltIns(mk);
			mk= changeBuiltInMarkToCommonMark(mk);
		end
		__initQualifiers__(mk);
		__initMethodType__(mk);
		__initPrototype__(p);
	end ##}}}
	def addBody procs ##{{{
		procs.each do |l|
			@body << l;
		end
		return;
	end ##}}}

	def __initBuiltinMarks__ ##{{{
		@builtinMarks = ['new','build','connect','run'];
	end ##}}}
	def __isBuiltIns__ mk ##{{{
		return true if @builtinMarks.include?(mk);
		return false;
	end ##}}}
	"""
	builtin mark like **build** should be converted to **vfunc**
	"""
	def changeBuiltInMarkToCommonMark mk ##{{{
		return 'func'  if mk=='new';
		return 'vfunc' if mk=='build' or mk=='connect';
		return 'vtask' if mk=='run';
	end ##}}}

	"""
	according to the input builtin mark (new,build,...), create a prototype string like a
	normal method used. For example:
	'void build_phase(uvm_phase phase)'
	"""
	def createProtoAndBodyForBuiltIns mk ##{{{
		return __initNew__ if mk=='new';
		return __initFuncPhase__(mk) if mk=='build' or mk=='connect';
		return __initTaskPhase__(mk) if mk=='run';
	end ##}}}
	def __initNew__ ##{{{
		@noReturnType = true;
		p = 'new(string name="';
		p += @container.name+'"';
		p += ',uvm_component parent=null' if @container.isComponent?;
		p += ')';
		if @container.isComponent?
			addBody(['super.new(name,parent);']);
		else
			addBody(['super.new(name);']);
        end
		return p;
	end ##}}}
	def __initFuncPhase__ mk ##{{{
		phase = mk+'_phase';
		p = 'void '+phase+'(uvm_phase phase)';
		addBody(['super.'+phase+'(phase);'])
		return p;
	end ##}}}
	def __initTaskPhase__ mk ##{{{
		phase = mk+'_phase';
		p = phase+'(uvm_phase phase)';
		addBody(['super.'+phase+'(phase);'])
        return p;
	end ##}}}
	def __initMethodType__ mk ##{{{
		if /task/.match(mk)
			@type = :task;
		else
			@type = :function;
		end
		return;
	end ##}}}

	def __extractQualifiersFromMark__ mk ##{{{
		@qualifiers<<'virtual' if mk[0]=='v';
		@qualifiers<<'static'  if mk[0]=='s';
		@qualifiers<<'local'   if mk[0]=='l';
		@qualifiers<<'virtual' if mk[1]=='v';
		@qualifiers<<'static'  if mk[1]=='s';
		@qualifiers<<'local'   if mk[1]=='l';
	end ##}}}
	def __initQualifiers__ mk ##{{{
		@qualifiers = [];
		@qualifiers << 'extern';
		__extractQualifiersFromMark__(mk);
	end ##}}}
	def __initPrototype__ p ##{{{
		@prototype = [];
		@returnType= '';
		@name = '';
		if p.is_a?(String)
			@prototype << p;
		else
			@prototype.push(*p);
		end
		if @type==:function and @noReturnType==false
			md = /(\S+) +/.match(@prototype[0]);
			if md==nil
				puts "Error, no return type detected for a function";
				return;
			end
			@returnType = md[1];
			@prototype[0].sub!(md[0],'');
		end
		md = /([\w|_]+) *\(/.match(@prototype[0]);
		@name = md[1];
		return;
	end ##}}}



	def prototype f=:declare ##{{{
		formatted = [];
		i = 0;
		head = '';
		if f==:declare
			@qualifiers.each do |q|
				head += q+' ';
			end
		end
		head += @type.to_s+' ';
		head += @returnType+' ' if @type==:function;
		head += @container.name+'::' if f!=:declare;
		head += @prototype[0];
		formatted << head;
		for i in (1..@prototype.length()-1) do
			formatted << @prototype[i];
		end
		formatted[i] += ';';
		return formatted;
	end ##}}}

	def body ##{{{
		bodyCodes = [];
		bodyCodes.push *(prototype(:define));
		@body.each do |l|
			bodyCodes << "\t"+l;
		end
		bodyCodes << 'end'+@type.to_s;
		return bodyCodes;
	end ##}}}
end ##}
