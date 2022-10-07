basic architecture of this program, use 'mdc' as the command name. locates in $PROJECT_HOME/ 
# File Structure
- ./mdc , executor
- ./lib/, lib dir, stores all included files
- ./test dir,test program.
# Generic Procedures
- load source md file
- detecting key words
- smart automatic building
- generate target files

# Main Entry
MainEntry class is for starting the generic procedures, calling in mdc executor is like:
```
rhload 'lib/mainentry';

e = MainEntry.new();
$SIG = e.run();
exit $SIG
```

# Load source md file
currently this tool support input source md files only, users can invoke this tool simply like: `mdc test.md`
# Detect keywords
the flags of source code are quoted by double `**`, so different keywords with these symbols will be captured and used by the keyword capture procedures. Will use procedures like:
```
for i=0;i<maxlines;i++
	if (detectedKey)
		captureContents
		i+=capturedLines
	else continueNextLine
end
```
# Smart building
after capturing all key information, this tool will start building the target file, according to different target type (currently supports C++ and SV only).
building steps are:
- file architecture building, things like file name, file macros, file description etc.
- for building classes, use prototype or procedures, which will build:
	- class head, declaration of class
	- class body
- for other blocks, simply use one of above types to build

