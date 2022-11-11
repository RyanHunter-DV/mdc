#! /usr/bin/env ruby
require 'rhload'
cdir = File.dirname(File.absolute_path(__FILE__));
$LOAD_PATH << cdir+'/../../';

rhload 'lib/svTLM.rb';



def main() ##{{{
	testAIType;
	testAPType;
end ##}}}

def testAIType ##{
	tlm = SVTLM.new('tlm-ai');
	tlm.setup('suffix','transType','portName','className');
	lines = [
		'// todo, code line 1',
		'// todo, code line 2'
	];
	tlm.addProcedures(lines);
	puts "[testAIType]:";
	puts "code to create port:";
	puts tlm.createInSV;
	puts "code of write prototype:";
	puts tlm.writePrototypeCode;
	puts "code of write body:";
	puts tlm.writeBodyCode;
end ##}

def testAPType ##{
	tlm = SVTLM.new('tlm-ap');
	tlm.setup('transType','portName','className');

	puts "[testAPType]:";
	puts "code to create port:";
	puts tlm.createInSV;
end ##}

def testAEType ##{
	tlm = SVTLM.new('tlm-ae');
	tlm.setup('transType','portName','className');

	puts "[testAEType]:";
	puts "code to create port:";
	puts tlm.createInSV;
end ##}

main();