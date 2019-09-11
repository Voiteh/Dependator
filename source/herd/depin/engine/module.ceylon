"""
   This is core module for dependency injection framework Depin. 
   The whole concept of this framework is based on [[Dependency]] class and [[Injection]] interface. 
   Both are tithly coupled togather. To use this framework, one need to first provide dependencies for further injection. 
   It is done using [[scanner]] object. Scanning is gathering of function and value declaration annotated with [[DependencyAnnotation]].
   They can be nested in classes and member classes or top level .    
   Example scanning:
   
   		shared dependency String topLevelValue="some value";
   		shared dependency Integer topLevelFunction(String someString) => someString.lenght;
   		value depedencencyDeclarations=scanner.scan({`module`}};
   	
   	Would provide dependencies for further use. [[Scope]] is range on which scanning would execute. Dependency declarations can be gathered manualy.
   	
   		
"""
module herd.depin.engine "1.0.0" {
	
	shared import ceylon.logging "1.3.3";
	shared import ceylon.collection "1.3.3";
	import herd.type.support "0.2.0";
}
