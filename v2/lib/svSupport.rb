rhload 'lib/database.rb';
rhload 'lib/svMarkPool.rb';
rhload 'lib/svClass.rb';
rhload 'lib/svTLM.rb';
rhload 'lib/svPackage.rb';

class SVSupport < DataBase ##{

	attr :svclasses;
	attr :svpackages;
	attr :fp;

	def initialize _fp ##{{{
		@svclasses = [];
		@svpackages= [];
		@fp = _fp;
		@mkpool = SVMarkPool.new(@fp);
	end ##}}}

	def currentClass ##{{{
		idx = @svclasses.length() - 1;
		return @svclasses[idx];
	end ##}}}

	def __processClass__ mk ##{{{
		svc = SVClass.new(mk[:name],mk[:uvmtype]); ## TODO
		svc.tparam = mk[:tparam] if mk.has_key?(:tparam);
		svc.param  = mk[:param]  if mk.has_key?(:param);
		svc.base   = mk[:base]   if mk.has_key?(:base);
		@svclasses << svc;
	end ##}}}
	def __processFields__ mk ##{{{
		cls = currentClass();
		cls.addField(mk[:fields]);
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
		setupString << cls.name;
		if mk[:mark]=='tlm-ai'
			_tmp = setupString.shift();
			setupString << _tmp;
		end
		tlm.setup(*setupString);
		tlm.addProcedures if (mk.has_key?(:proc));
		cls.addTLM(tlm);
	end ##}}}
	def __processPackage__ mk ##{{{
		pkg = SVPackage.new(mk[:name],mk[:body]);
		@svpackages << pkg;
	end ##}}}

	def processSource ##{{{
		@mkpool.marks.each do |mk|
			__processClass__(mk)   if mk[:type]==:svclass;
			__processFields__(mk)  if mk[:type]==:field;
			__processMethods__(mk) if mk[:type]==:method;
			__processTLMs__(mk)    if mk[:type]==:tlm;
			__processPackage__(mk) if mk[:type]==:package;
		end
	end ##}}}



end ##}