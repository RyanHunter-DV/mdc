rhload 'lib/commonMark'
rhload 'lib/svTLM'

class SVClass < CommonMark ##{
	attr :type;
	attr :param;
	attr :tparam;
	attr :base;
	attr :fields;
	attr_accessor :name;
	attr :tlms;

	def initialize n ##{{{
		super;
		@name   = n;
		@type   = :svclass;
		@param  = '';
		@tparam = '';
		@base   = '';
		@fields = [];
		@tlms   = [];

		loadSupportiveMarks 'class',[
			'class','vclass',
			'driver','monitor','sequencer','agent','component',
			'sequence','transaction','object'
		];
		loadSupportiveMarks 'param',['param','tparam'];
		loadSupportiveMarks 'base',['base'];
		loadSupportiveMarks 'field',['field'];
		loadSupportiveMarks 'tlm',['ap-imp','ap-port'];
		__loadDefaultSetupFile__;
	end ##}}}

	"""
	defaultSetup: called by builtins to setup different components
	"""
	def defaultSetup n &block ##{{{
		define_singleton_method n.to_sym do
			block.call;
		end
	end ##}}}
	def isComponent ##{{{
		if (
			@type==:uvm_component or
			@type==:uvm_driver or
			@type==:uvm_monitor or
			@type==:uvm_sequencer or
			@type==:uvm_agent
		)
			return true;
		else
			return false;
		end
	end ##}}}
	def isObject ##{{{
		if (
			@type==:uvm_object or
			@type==:uvm_sequene or
			@type==:uvm_sequence_item
		)
			return true;
		else
			return false;
		end
	end ##}}}
	"""
	setMark: this API will generate a class declaration header according to input mark
	for example, if mark is 'vclass', then type will be 'virtual class', and also the
	default type will be set according to input mark, if mark is 'driver', then a default
	base 'uvm_driver#(REQ,RSP)' and default param 'type REQ=uvm_sequence_item,RSP=REQ' will
	be set
	"""
	def setMark mk ##{{{
		self.instance_eval mk;
	end ##}}}

	def __loadDefaultSetupFile__ ##{{{
		fh = File.open($TOOLHOME+'builtins/defaultSVSetup');
		cnts = fh.readlines();
		self.instance_eval cnts;
	end ##}}}

	"""
	extractClassname: for getting class name after a mark like **driver**
	After detecting the class name, it will overwrite the original @name field.
	"""
	def extractClassName fp ##{{{
		linenum = fp.currentLine - 1; ## current line is next line after this mark
		@name = extractOnelineMarkInfo(fp.getline(linenum)); 
		if @name==''
			puts "*E, class definition is illegal (#{fp.getline(linenum)})";
		end
		return;
	end ##}}}

	def extractParam mk,fp ##{{{
		_param = '';
		linenum = fp.currentLine-1;

		_param = extractOnelineMarkInfo(fp.getline(linenum));
		if _param==''
			puts "*E, param definition is illegal (#{fp.getline(linenum)})";
			return;
		end			
		if mk=='param'
			@param = _param;
		else
			@tparam= _param;
		end
	end ##}}}

	def extractBase mk,fp ##{{{
		linenum = fp.currentLine-1;
		_base = extractOnelineMarkInfo(fp.getline(linenum));
		if _base==''
			puts "no available base detected (#{fp.getline(linenum)}), will use default";
		else
			@base = _base;
		end
	end ##}}}
	def extractField mk,fp ##{{{
		_field = extractMultlineMarkInf(fp);
		@fields.append(*_field) unless _field.empty?;
		return;
	end ##}}}

	def extractTLM mk,fp ##{{{
		linenum = fp.currentLine-1;
		tlm = SVTLM.new(mk,@name);
		fmts = extractOnelineMarkInfo(fp.getline(linenum)).split(' ');
		tlm.setup(*fmts);
		@tlms << tlm;
		return tlm;
	end ##}}}
	def uvmutils ##{{{
		declbegin = '`uvm_';
		declend = '`uvm_';
		if isComponent
			declbegin+='component_';
			declend+='component_';
		else
			declend+='object_';
			declend+='object_';
		end
		declbegin+='utils_begin('+name+')';
		declend+='utils_end'
		@fields << declbegin;
		@fields << declend;
	end ##}}}
end ##}