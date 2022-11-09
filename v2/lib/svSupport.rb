rhload 'lib/svMarkPool';

class SVSupport < DataBase ##{

	attr :svclasses;
	attr :fp;

	def initialize _fp ##{{{
		@svclasses = [];
		@fp = _fp;
		@mkpool = SVMarkpool.new(@fp);
	end ##}}}

	def currentClass ##{{{
		idx = @svclasses.length() - 1;
		return @svclasses[idx];
	end ##}}}

	def __processClass__ mk ##{{{
		svc = SVClass.new(mk[:name],mk[:uvmtype]); ## TODO
		svc.tparam = mk[:tparam] if mk.exists?(:tparam);
		svc.param  = mk[:param]  if mk.exists?(:param);
		svc.base   = mk[:base]   if mk.exists?(:base);
		@svclasses << svc;
	end ##}}}
	def __processFields__ mk ##{{{
		cls = currentClass();
		cls.addField(mk[:fields]);
	end ##}}}
	def __processMethods__ mk ##{{{
		cls = currentClass();
		m = SVMethod.(mk[:proto],cls,mk[:mark]);
		m.addBody(mk[:proc]) if (mk.exists?(:proc));
		cls.addMethod(m);
	end ##}}}
	def __processTLMs__ mk ##{{{
		tlm = SVTLM.new(mk[:mark]);
		tlm.setup(mk[:proto].split());
		tlm.addProcedures if (mk.exists?(:proc));
	end ##}}}

	def processSource ##{{{
		@mkpool.marks.each do |mk|
			__processClass__(mk)   if mk[:type]==:svclass;
			__processFields__(mk)  if mk[:type]==:field;
			__processMethods__(mk) if mk[:type]==:method;
			__processTLMs__(mk)    if mk[:type]==:tlm;
		end
	end ##}}}



end ##}