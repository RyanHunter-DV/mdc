rhload 'lib/database.rb';
rhload 'lib/svMarkPool.rb';
rhload 'lib/svClass.rb';
rhload 'lib/svTLM.rb';
rhload 'lib/svPackage.rb';

class SVSupport < DataBase ##{

	attr_accessor :classes;
	attr_accessor :codeType;
	attr_accessor :nullclass;
	attr :packages;
	attr :fp;

	def initialize _fp,ct ##{{{
		@classes = [];
		@packages= [];
		@fp = _fp;
		@codeType = ct;
		@mkpool = SVMarkPool.new(@fp);
		@nullclass= SVClass.new('null','class');
	end ##}}}

	def currentClass ##{{{
		idx = @classes.length() - 1;
		return @nullclass if idx < 0;
		return @classes[idx];
	end ##}}}

	def __processClass__ mk ##{{{
		svc = SVClass.new(mk[:name],mk[:mark],mk[:uvmtype]); ## TODO
		svc.tparam = mk[:tparam] if mk.has_key?(:tparam);
		svc.param  = mk[:param]  if mk.has_key?(:param);
		svc.base   = mk[:base]   if mk.has_key?(:base);
		@classes << svc;
	end ##}}}
	def __processFields__ mk ##{{{
		cls = currentClass();
		cls.addField(mk[:fields]);
	end ##}}}
	def __processFieldut__ mk ##{{{
		cls = currentClass();
		cls.addFieldut(mk[:fieldut]);
	end ##}}}
	def __processMethods__ mk ##{{{
		cls = currentClass();
		m = SVMethod.new(mk[:proto],cls,mk[:mark]);
		m.addBody(mk[:proc]) if (mk.has_key?(:proc));
		cls.addMethod(m);
	end ##}}}
	def __processTLMs__ mk ##{{{
		tlm = SVTLM.new(mk[:mark]);
		cls = currentClass();
		setupString = mk[:proto].split(' ');
		setupString << cls;
		if mk[:mark]=='tlm-ai'
			_tmp = setupString.shift();
			setupString << _tmp;
		end
		tlm.setup(*setupString);
		tlm.addProcedures mk[:proc] if (mk.has_key?(:proc));
		cls.addTLM(tlm);
	end ##}}}
	def __processPackage__ mk ##{{{
		pkg = SVPackage.new(mk[:name],mk[:body],mk[:head]);
		@packages << pkg;
	end ##}}}

	def processSource ##{{{
		@mkpool.marks.each do |mk|
			__processClass__(mk)   if mk[:type]==:svclass;
			__processFields__(mk)  if mk[:type]==:field;
			__processFieldut__(mk)  if mk[:type]==:fieldut;
			__processMethods__(mk) if mk[:type]==:method;
			__processTLMs__(mk)    if mk[:type]==:tlm;
			__processPackage__(mk) if mk[:type]==:package;
		end
	end ##}}}



end ##}
