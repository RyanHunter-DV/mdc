#! /usr/bin/env ruby
require 'rhload'
cdir = File.dirname(File.absolute_path(__FILE__));
$LOAD_PATH << cdir+'/../../';
require 'lib/svPackage.rb'

def main ##{
	rawBody = [
		'import RHVipBase::*',
		'include common/rhAxi4If.sv\ncommon/rhAxi4Types.svh',
		'include mst/rhAxi4MstDriver.svh\nmst/rhAxi4Mst.svh'
	]
	package = 'RhAxi4Vip';
	pkg = SVPackage.new(package,rawBody);
	puts "test results:"
	puts "package: #{pkg.name}";
	puts "body:";
	puts pkg.body;
	puts "interface:";
	puts pkg.interface;
end ##}

main();