rhload 'lib/svTLM'

class SVClass ##{
	attr_accessor :name;
	attr_accessor :tparam;
	attr_accessor :param;
	attr_accessor :base;
	attr :uvmtype;

	def initialize n,uvmt##{{{
		@name = n.to_s;
		@uvmtype = uvmt.to_sym;
		@tparam = '';
		@param  = '';
		@base   = '';
	end ##}}}
end ##}