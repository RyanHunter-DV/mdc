class SVTLM ##{
	attr_accessor :type;
	attr_accessor :suffix;
	attr_accessor :trans;
	attr_accessor :container;
	attr_accessor :instname;

	def initialize t,c ##{{{
		@type = t.to_s;
		@container = c.to_s;
		@suffix = nil;
		@trans  = nil;
		@instname  = nil;
	end ##}}}

	def setup *args ##{{{
		if @type=='ap-imp'
			@suffix  = args[0];
			@trans   = args[1];
			@instname= args[2];
		end
		if @type=='ap-port'
			@trans   = args[0];
			@instname= args[1];
		end
		return;
	end ##}}}

end ##}