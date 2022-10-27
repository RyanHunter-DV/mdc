require 'optparse'
class ToolOptions ##{
	attr_accessor :source;
	attr_accessor :help;


	def __setupOptionParser ##{{{
		OptionParser.new() do |opts|
			opts.on('-h','--help',"display help message") do
				@help = true;
			end
			opts.on('-s','--source=FILE',"specifying a source file") do |f|
				@source = f;
			end
		end.parse!
	end ##}}}

	def initialize
		@help   = false;
		@source = '';
		__setupOptionParser;
	end

	def isHelpMode
		return false if @help==false;

		## TODO, display help information before return true
		return true;
	end
end ##}