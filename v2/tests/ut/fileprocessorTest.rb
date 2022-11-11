#! /usr/bin/env ruby

require 'rhload'
cdir = File.dirname(File.absolute_path(__FILE__));
$LOAD_PATH << cdir+'/../../';

rhload 'lib/fileProcessor.rb'


def main
	fn = 'test.md';
	fp = FileProcessor.new(fn);
	__markTest__(fp);
end

def __markTest__ fp
	mark = '<init>';
	method = {};
	while (mark!='')
		mark = fp.getNextMark;
		puts "mark: #{mark}";
		if (mark=='func')
			p = fp.extractOnelineMarkInfo;
			fp.extractMultlineMarkInfo if (p=='');

			method[:proto] = p;
		end
		if (mark=='proc')
			method[:proc] = fp.extractMultlineMarkInfo;
		end
	end
	puts "test func mark"
	puts "proto: #{method[:proto]}";
	puts "body:"
    puts method[:proc];
end



main();