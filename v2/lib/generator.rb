class Generator ##{
	attr :db;
	attr :tDir;
	attr :tFile;
	attr :macroMark;
	def initialize _db,sn,td ##{{{
		@db = _db;
		@macroMark='#';
		@tDir = td;
		__setupTargetFileName__(sn);
	end ##}}}

	def __setupTargetFileName__ sn ##{{{
		@tFile='';
		sn.sub!('.md','');
		fn = File.basename(sn);
		dir= File.dirname(sn);
		md = /-([\w|_]+\.\w+)/.match(fn);
		fn = md[1] if md;
		## @tDir = dir;
		@tFile= fn;
	end ##}}}

	def __generateFileHeader__ ##{{{
		commentMark = '//';
		cnts = [];
		@macroMark = '`' if @db.codeType==:SV;
		mCnt = @tFile.sub(/\./,'__');
		cnts << @macroMark+'ifndef '+mCnt;
		cnts << @macroMark+'define '+mCnt
		return cnts;
	end ##}}}
	def __generateNullClass__ ##{{{
		cnts = [];
		@db.nullclass.bodyCode.each do |cl|
			cnts << cl;
		end
		return cnts;
	end ##}}}
	def __generateFileContents__ ##{{{
		cnts = [];
		@db.classes.each do |cls|
			cnts << cls.declareCode;
			cls.bodyCode.each do |cl|
				cnts << "\t"+cl;
			end
			if @db.codeType==:SV
				if cls.type=='interface'
					cnts<<"endinterface";
				else
					cnts << "endclass";
				end
			else
				cnts << "};"
			end
			cnts.push(*cls.methodsCode);
		end
		cnts = __generateNullClass__ if @db.classes.length()==0;
		@db.packages.each do |p|
			cnts << p.interfaceCode;
			cnts << p.declareCode;
			p.bodyCode.each do |cl|
				cnts << "\t"+cl;
			end
			if @db.codeType==:SV
				cnts<<"endpackage";
			end
		end
		return cnts;
	end ##}}}
	def __generateFileTailer__ ##{{{
		return [@macroMark+'endif'];
	end ##}}}

	def publish ##{{{
		cnts = [];
		cnts.push(*__generateFileHeader__);
		cnts << "";
		cnts.push(*__generateFileContents__);
		cnts << "";
		cnts.push(*__generateFileTailer__);
		fh = File.open(@tDir+'/'+@tFile,'w');
		cnts.each do |l|
			fh.write(l+"\n");
		end
		return;
	end ##}}}
end ##}
