rhload 'lib/svMethod'
rhload 'lib/svField'
class SVTLM < SVField ##{
	attr_accessor :tlmType;
	attr_accessor :tlmName;
	attr_accessor :tlmSuffix;
	attr_accessor :transType;
	attr_accessor :container;
	attr_accessor :write;

	def initialize mk ##{{{
		@tlmType = mk.to_s;
		@transType = '';
		@tlmName   = '';
		@container = nil;
		@tlmSuffix = '';
		@write = nil;
		@type  = :tlm; ## field type
	end ##}}}
	def __isImp__ ##{{{
		return true if @tlmType=='tlm-ai';
		return false;
	end ##}}}
	def setup *args ##{{{
		@transType = args[0];
		@tlmName   = args[1];
		@container = args[2];
		@tlmSuffix = args[3] if __isImp__;
		return;
	end ##}}}

	def addProcedures lines ##{{{
		return if not __isImp__;
		fn = 'write_'+@tlmSuffix;
		proto = 'void '+fn+'('+@transType+' _tr)';
		@write = SVMethod.new(proto,@container);
		@write.addBody(lines);
	end ##}}}

	"""
	API to generate a string that to create a new TLM in SV.
	"""
	def createInSV ##{{{
		line = @tlmName+' = new("'+@tlmName+'",this);';
		return line;
	end ##}}}

	"""
	writePrototypeCode and writeBodyCode are methods that return the prototype/body of SV
	"""
	def writePrototypeCode ##{{{
		return @write.prototype;
	end ##}}}
	def writeBodyCode ##{{{
		return @write.body;
	end ##}}}

end ##}