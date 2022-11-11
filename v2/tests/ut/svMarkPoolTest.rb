#! /usr/bin/env ruby
require 'rhload'
cdir = File.dirname(File.absolute_path(__FILE__));
$LOAD_PATH << cdir+'/../../';

require 'lib/svMarkPool.rb'
require 'lib/fileProcessor.rb'



## test dependent on file processor
def main
	fn = 'test.md';
	fp = FileProcessor.new(fn);
	mkpool = SVMarkPool.new(fp);
    mkpool.marks.each do |mk|
        puts "mk: #{mk}"
    end
end

main();