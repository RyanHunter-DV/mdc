require '../../lib/svMarkPool.rb'
require '../../lib/fileProcessor.rb'


main();

## test dependent on file processor
def main
	fp = FileProcessor.new();
	mkpool = SVMarkPool.new(fp);
end