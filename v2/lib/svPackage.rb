
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
			splits[1].split("\n").each do |v|
				item = {:type=>type,:value=>v};
				@body << item;
			end
		end
	end ##}}}


end ##}