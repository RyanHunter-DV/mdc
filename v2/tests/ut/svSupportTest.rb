#! /usr/bin/env ruby
require 'rhload'
cdir = File.dirname(File.absolute_path(__FILE__));
$LOAD_PATH << cdir+'/../../';

rhload 'lib/svSupport.rb'
rhload 'lib/fileProcessor.rb'

def main ##{{{
	fn = 'test.md';
	fp = FileProcessor.new(fn);
	db = SVSupport.new(fp);
	db.processSource();
	__printResults__(db);
end ##}}}

def __printResults__ db ##{{{
	puts "done processing source file";
	puts "--------------------------------------------------------------";
	puts "db status:";
	puts "classnum: #{db.svclasses.length()}";
	db.svclasses.each do |cls|
		puts "class: #{cls.name}";
		puts "tparam: #{cls.tparam}";
		puts "param: #{cls.param}";
		puts "base: #{cls.base}"
		puts "fields:"
		cls.fields.each do |item|
			puts item;
		end
		puts "tlms:"
		cls.tlms.each do |tlm|
			puts tlm.declareInSV;
		end
		puts "methods:"
		cls.methods.each do |m|
			puts m.prototype;
		end
	end
	puts "--------------------------------------------------------------";
end ##}}}

main();