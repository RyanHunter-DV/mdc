class Generator ##{
	attr :db;
	attr :tDir;
	attr :tFile;
	attr :macroMark;
	def initialize _db,sn ##{{{
		@db = _db;
		@macroMark='#';
		__setupTargetFileName__(sn);
	end ##}}}

	def __setupTargetFileName__ sn ##{{{
		@tDir='';@tFile='';
		sn.sub!('.md','');
		fn = File.basename(sn);
		dir= File.dirname(sn);
		md = /-([\w|_]+\.\w+)/.match(fn);
		fn = md[1] if md;
		@tDir = dir;
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
	def __generateFileContents__ ##{{{
		cnts = [];
		@db.classes.each do |cls|
			cnts << cls.declareCode;
			cls.bodyCode.each do |cl|
				cnts << "\t"+cl;
			end
			if @db.codeType==:SV
				cnts << "endclass";
			else
				cnts << "};"
			end
			cnts.push(*cls.methodsCode);
		end
		return cnts;
	end ##}}}
	def __generateFileTailer__ ##{{{
		return [@macroMark+'endif'];
	end ##}}}

	def publish ##{{{
		cnts = [];
		cnts.push(*__generateFileHeader__);
		cnts.push(*__generateFileContents__);
		cnts.push(*__generateFileTailer__);
		fh = File.open(@tDir+'/'+@tFile,'w');
		cnts.each do |l|
			fh.write(l+"\n");
		end
		return;
	end ##}}}
end ##}