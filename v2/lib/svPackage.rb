
class SVPackage ##{
	attr_accessor :name;
	attr_accessor :body;
	attr_accessor :interface;

	def initialize n,rawBody ##{{{
		__initFields__(n);
		__assemblePackageBody__(rawBody);
		__filterInterfaceInclude__;
		__insertBuiltinItemsToBody__;
	end ##}}}
	def __insertBuiltinItemsToBody__ ##{{{
		item = {:type=>'import',:value=>'uvm_pkg::*'};
		@body.unshift(item);
		item = {:type=>'include',:value=>'uvm_macros.svh'};
		@body.unshift(item);
	end ##}}}
	def __initFields__ n ##{{{
		@name = n;
		@body = [];
		@interface = {};
	end ##}}}
	def __matchInterfaceFile__ f ##{{{
		return true if /If\.sv/.match(f) or /Interface\.sv/.match(f);
		return false;
	end ##}}}
	def __filterInterfaceInclude__ ##{{{
		@body.each do |item|
			if item[:type]=='include' and __matchInterfaceFile__(item[:value])
				@interface = item;
				@body.delete(item);
				break;
			end
		end
	end ##}}}
	def __assemblePackageBody__ raw ##{{{
		raw.each do |rl|
			splits = rl.split(' ');
			type = splits[0];
			next if splits.length()<=1;
			splits[1].split(';').each do |v|
				item = {:type=>type,:value=>v};
				@body << item;
			end
		end
	end ##}}}

	def declareCode ##{{{
		p = 'package '+@name+';';
		return p;
	end ##}}}

	def interfaceCode ##{{{
		l = '`include "'+@interface[:value]+'"';
		return l;
	end ##}}}
	def bodyCode ##{{{
		cnts = [];
		@body.each do |b|
			if b[:type]=='include'
				cnts << '`include "'+b[:value]+'"' if b[:value]!="" or (not /^\/\//.match(b[:value]));
			else
				cnts << 'import '+b[:value]+';' if b[:value]!="";
			end
		end
		return cnts;
	end ##}}}

end ##}
