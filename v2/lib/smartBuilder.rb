class SmartBuilder ##{
	attr :db;
	def initialize _db ##{{{
		@db = _db;
	end ##}}}

	def optimizeDataBase ##{{{
		@db.classes.each do |svc|
			next if svc.type=='interface';
			__builtinMethodsBuild__(svc);
			__builtinClassBuild__(svc);
		end
	end ##}}}

	"""
	1.setup default class type, such as default base, param etc.
	2.setup default fields, such as uvm_component_utils etc.
	"""
	def __builtinClassBuild__ svc ##{{{
		__setupDefaultClassDeclaration__(svc) if svc.base=='';
		__setupDefaultFields__(svc);
	end ##}}}
	def __setupDefaultFields__ c ##{{{
		decl = '`uvm_';
		if c.isObject?
			decl+='object_utils';
		else
			decl+='component_utils';
		end
		classfield = c.name;
		classfield = c.parameterizedClassName if c.param!=''or c.tparam!='';
		c.addField decl+'_begin('+classfield+')';
		c.fieldut.each do |fut|
			c.addField "\t"+fut;
		end
		c.addField decl+'_end';

	end ##}}}
	def __setupDefaultClassDeclaration__ c ##{{{
		if c.uvmtype=='driver' or c.uvmtype=='sequencer'
			c.base='uvm_'+c.uvmtype+'#(REQ,RSP)';
			c.tparam='REQ=uvm_sequence_item,RSP=REQ' if c.tparam==''
		else
			c.base='uvm_'+c.uvmtype.to_s;
		end
	end ##}}}

	"""
	For an object, if no new method in class, then add a default one
	For a component, if no new,build_phase,connect_phase, then add default
	This will be achieved through the defaultMethodSetup configure file.
	"""
	def __builtinMethodsBuild__ c ##{{{
		__setupDefaultMethod__('new',c) unless c.has?('new');
		if c.isComponent?
			__setupDefaultMethod__('build',c) unless (c.has?('build_phase'));
			__setupDefaultMethod__('connect',c) unless (c.has?('connect_phase'));
			__setupDefaultMethod__('run',c) unless (c.has?('run_phase'));
		end
	end ##}}}

	def __setupDefaultMethod__ mn,c ##{{{
		m = SVMethod.new('',c,mn);
		c.addMethod(m);
	end ##}}}

end ##}
