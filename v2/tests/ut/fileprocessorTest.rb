#! /usr/bin/env ruby
require '../../lib/fileProcessor.rb'

main();

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
		if (mark=='task')
			p = fp.extractOnelineMarkInfo;
			fp.extractMultlineMarkInfo if (p=='');

			method[:proto] = p;
		end
		if (mark=='proc')
			method[:proc] = fp.extractMultlineMarkInfo;
		end
	end
	puts "test task mark"
	puts "proto: #{method[:proto]}";
	puts "body: #{method[:proc]}"
end