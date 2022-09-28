This is v2 for MDC (markdown converter), aim to add more intellegent flags that can generate source code more easily.
# overview
## support file type
- SV
- C++
## common commands
**file**
test.cpp
**file**
test.h
**file**
test.svh
**class** 
```
virtual class testClass: baseClass;
```

**proto**
```
source code
// C++
public:
	extern void testCode();
```
**body**
```
// C++
	int a = 10;
	cout<<"a: "<<a<<endl;
```
