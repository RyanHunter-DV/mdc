#! /usr/bin/env ruby

require 'rhload'
cdir = File.dirname(File.absolute_path(__FILE__));
$LOAD_PATH << cdir+'/../../';
require 'lib/svMethod.rb'


def main ##{
	manualMethodTest();
	builtinMethodTest();
end ##}

def __builtinTestCore__ mk ##{{{
	m = __createSVMethod__('',mk);

	puts "builtin without manual code:"
	printResults('builtinMethodTest',m);

	puts "builtin with manual code:"
	body = ["port = new(\"testPort\",this);"];
	m.addBody(body);
	body = ["port2 = new(\"testPort2\",this);"];
	m.addBody(body);
	printResults('builtinMethodTest',m);
end ##}}}
def builtinMethodTest ##{{{
	mark = 'new';    __builtinTestCore__(mark);
	mark = 'build';  __builtinTestCore__(mark);
	mark = 'connect';__builtinTestCore__(mark);
	mark = 'run';    __builtinTestCore__(mark);
end ##}}}

def manualMethodTest() ##{{{
	puts "start manualMethodTest";
	testManualTasks();
	testManualFuncs();
end ##}}}
def testManualFuncs ##{{{
	pline = "bit[31:0] singleLinePrototype(input bit[1:0] a,output bit[10:0] b)";
	mark  = "func";
	sbody = ["one line body;"];
	mbody = ["multiple line body 1;","\tmultiple line body 2;","multiple line body 3;"];
	m =__createSVMethod__(pline,mark);
	m.addBody(mbody);
	m.addBody(sbody);
	printResults('testManualFuncs',m);

	## multiple prototype declaring
	pline = [
		'int multLinePrototype (',
		'input bit[1:0] a,',
		'output bit[2:0] b',
		')'
	];
	m = __createSVMethod__(pline,mark);
	m.addBody(sbody);
	m.addBody(mbody);
	printResults('testManualFuncs',m);
end ##}}}
def testManualTasks ##{{{
	pline = "singleLinePrototype(input bit[1:0] a,output bit[10:0] b)";
	mark  = "task";
	sbody = ["one line body;"];
	mbody = ["multiple line body 1;","\tmultiple line body 2;","multiple line body 3;"];
	m =__createSVMethod__(pline,mark);
	m.addBody(mbody);
	m.addBody(sbody);
	printResults('testManualTasks',m);

	## multiple prototype declaring
	pline = [
		'multLinePrototype (',
		"\tinput bit[1:0] a,",
		"\toutput bit[2:0] b",
		')'
	];
	m = __createSVMethod__(pline,mark);
	m.addBody(sbody);
	m.addBody(mbody);
	printResults('testManualTasks',m);
end ##}}}

def printResults n,m ##{{{
	svcode = [];
	svcode.push *m.prototype;
	svcode << "// next for body declaration //";
	svcode.push *m.body;
	puts "[#{n}] test print";
	svcode.each do |l|
		puts l;
	end
end ##}}}

## this is defined for test only
class SVClass ##{
	attr_accessor :name;
	attr :component;
	def initialize n,c=false ##{
		@name = n.to_s;
		@component = c;
	end ##}
	def isComponent
		return @component;
	end
end ##}

def __createSVMethod__ p,mk ##{{{
	cls = SVClass.new("TestClass");
	m = SVMethod.new(p,cls,mk);
	return m;
end ##}}}

main();