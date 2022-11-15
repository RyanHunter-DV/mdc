rhload 'lib/svTLM'

class SVClass ##{
	attr_accessor :name;
	attr_accessor :tparam;
	attr_accessor :param;
	attr_accessor :base;
    attr_accessor :fields;
    attr_accessor :methods;
    attr_accessor :tlms;
	attr_accessor :type;
	attr :uvmtype;
	attr :comptypes;

	def initialize n,mk,uvmt=''##{{{
		@name = n.to_s;
		@type = mk if mk.to_s=='interface';
		@uvmtype = uvmt.to_sym if uvmt!='';
		@tparam = '';
		@param  = '';
		@base   = '';
        @fields = [];
        @methods= [];
        @tlms   = [];
		@comptypes = ['component','driver','agent','monitor','env','test','sequencer'];
	end ##}}}

    def addField fields ##{{{
        @fields.push(*fields);
    end ##}}}
    def addMethod m ##{{{
        @methods << m;
    end ##}}}
    def addTLM tlm ##{{{
        @tlms << tlm;
    end ##}}}
	def has? n ##{{{
		@methods.each do |m|
			return true if m.name = n;
		end
		return false;
	end ##}}}
	def isObject? ##{{{
		return true unless @comptypes.include?(@uvmtype);
		return false;
	end ##}}}
	def isComponent? ##{{{
		return false if (self.isObject?);
		return true;
	end ##}}}

	def declareCode ##{{{
		l='';p='';
		if @type=='interface'
			l = 'interface '+@name;
		else
			l = 'class '+@name;
		end
		p = ' #(' if @param!='' or @tparam!='';
		p += ' '+@param if @param!='';
		if @tparam!=''
			p+=',' if @param!='';
			p+=' type '+@tparam;
		end
		p += ')' if @param!='' or @tparam!='';
		if @type=='interface'
			l.sub!(/\(/,"#{p}(");
		else
			l += p;
		end
		l += ' extends '+@base if @base!='';
		## l += '()' if @type=='interface';
		l += ';';
		return l;
	end ##}}}
	"""
	This API will rearrange all SV code for defining a class, which contains:
	- body/field declaration within class
	"""
	def bodyCode ##{{{
		cnts = [];
		@tlms.each do |tlm|
			cnts << tlm.declareInSV;
		end
		cnts.push(*@fields);
		@methods.each do |m|
			cnts.push(*m.prototype);
		end
		return cnts;
	end ##}}}

	"""
	- method bodies after class declaration
	"""
	def methodsCode ##{{{
		cnts = [];
		@methods.each do |m|
			cnts.push(*m.body);
		end
		return cnts;
	end ##}}}

end ##}
