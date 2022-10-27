rhload 'lib/svMethod'
rhload 'lib/svClass'

class SVSupport < DataBase ##{
	attr :fp;
	attr :mps; ## collecting all marker processors.
	attr :cls; ## object of SV classes
	attr :ms;  ## object of SV methods
	"""
	__loadSupportiveMarks, to load all supported marks of the md file, which can be used
	in source file processing.
	"""
	def initialize _fp
		@fp  = _fp;
		@mps = [];
		## only support one class for each source now
		@cls = SVClass.new('<init>');
		@ms  = [];
	end

	## accessor for fp easily.
	def fp; return @fp; end
	def mps; return @mps; end
	def cls; return @cls; end


	def isMethodMark mk ##{{{
		if SVMethod.marks.include?(mk)
			return true;
		else
			return false;
		end
	end ##}}}
	def __processMethodMark mk ##{{{
		m = SVMethod.new(mk,cls.name);
		m.extractPrototype(fp) unless m.isBuiltin;
		m.extractProcedures(fp);
		@ms << m;
	end ##}}}

	def isClassMark mk ##{{{
		if @cls.classMarks.include?(mk)
			return true;
		else
			return false;
		end
	end ##}}}
	def isParamMark mk ##{{{
		if @cls.paramMarks.include?(mk)
			return true;
		else
			return false;
		end
	end ##}}}
	def isBaseMark mk ##{{{
		if @cls.baseMarks.include?(mk)
			return true;
		else
			return false;
		end
	end ##}}}
	def isFieldMark mk ##{{{
		if @cls.fieldMarks.include?(mk)
			return true;
		else
			return false;
		end
	end ##}}}
	def isTLMMark mk ##{{{
		if @cls.tlmMarks.include?(mk)
			return true;
		else
			return false;
		end
	end ##}}}

	def __processClassMark mk ##{{{
		@cls.setMark(mk); ## according to mk, default base will generated
		@cls.extractClassName(fp);
	end ##}}}
	def __processParamMark mk ##{{{
		return if @cls == nil;
		@cls.extractParam(mk,fp);
	end ##}}}
	def __processBaseMark mk ##{{{
		return if @cls==nil;
		@cls.extractBase(mk,fp);
	end ##}}}
	def __processFieldMark mk ##{{{
		return if @cls==nil;
		@cls.extractField(mk,fp);
	end ##}}}
	def __processTLMMark mk ##{{{
		return if @cls==nil;
		tlm = @cls.extractTLM(mk,fp);
		if (mk=='ap-imp')
			m = SVMethod.new('func',cls.name);
			m.setupTLMMethod(tlm,fp);
		end
	end ##}}}

	def __processMark mk ##{{{
		__processMethodMark(mk) if isMethodMark(mk);
		__processClassMark(mk)  if isClassMark(mk);
		__processParamMark(mk)  if isParamMark(mk);
		__processBaseMark(mk)   if isBaseMark(mk);
		__processFieldMark(mk)  if isFieldMark(mk);
		__processTLMMark(mk)    if isTLMMark(mk);
	end ##}}}
	"""
	processSource: API to process the source file in @fp object
	"""
	def processSource ##{{{
		mark = '<init>'; ## init
		## loop until get an empty mark.
		while (mark != '')
			mark = fp.getNextMark;
			__processMark(mark);
		end
	end ##}}}
end ##}