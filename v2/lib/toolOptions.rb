require 'optparse'
class ToolOptions ##{
	attr_accessor :source;
	attr_accessor :sourcePath;
	attr_accessor :targetPath;
	attr_accessor :help;
	attr_accessor :tDir;

	def __setupDefaultOption__ ##{{{
		@tDir = '.';
		@sourcePath = '.';
		@targetPath = '.';
	end ##}}}

	def __setupOptionParser ##{{{
		__setupDefaultOption__;
		OptionParser.new() do |opts|
			opts.on('-h','--help',"display help message") do
				@help = true;
			end
			opts.on('-s','--source=FILE',"specifying a source file") do |f|
				@source = f;
			end
			opts.on('-o','--targetDir=FILE',"specifying a target directory") do |d|
				@tDir = d;
			end
			opts.on('-p','--sourcePath=PATH',"specifying a source path") do |p|
				@sourcePath = p;
			end
			opts.on('-t','--targetPath=PATH',"specifying a target path") do |p|
				@targetPath = p;
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
