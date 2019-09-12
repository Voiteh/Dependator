"""
   This is core module, for dependency injection framework Depin. 
   The whole concept of this framework is based on [[Dependency]] class and [[Injection]] interface. 
   Both are tightly coupled togather. 
   The [[Dependency]] class is wrapped declaration with additional information like [[Identification]],
   providing ability to clearly identify what to inject in [[Injection]].
   [[Dependency]] is identified by it's name and declaration open type. 
   From point of view of [[Injection]], Two declaration (and after provisioning [[Dependency]]) having same name,
   (for example from different packages), with different open types are not coliding. [[Dependency]] has also ability to be resolved.
   Resolvance process is executed via [[Dependency.resolve]] attribute, this is done every time dependency has been identified and being injected.
   [[Injection]] is process of resolving dependencies (container and parameters) and calling requested constructor method or getting value.   
        
   To use this framework, one need to first provide dependencies, for further injection. 
   It is done using [[scanner]] object. Scanning is gathering of  and value declaration annotated with [[DependencyAnnotation]].
   
   They can be nested in classes and member classes or top level, any formal declaration will be rejected. 
   Example scanning:
   
   		shared dependency String topLevelValue="some value";
   		shared dependency Integer topLevelFunction(String someString) => someString.lenght;
   		value depedencencyDeclarations=scanner.scan({`module`}};
   	
   Would provide dependencies for further use. [[scanner.scan]] function takes [[Scope]]s as paremeters.
   [[Scope]] is range on which scanning would execute. When declaration are allready scaned they can be used for,
   [[Depin]] class object creation. [[Depin]] will convert declarations into [[Dependency]]'ies  and provide [[Depin.inject]] method.
   Now the injection can happen. [[Depin.inject]] requires [[Injectable]] parameter which is class method or value model to which injection will happen. 

   Example:
   		
   		shared Integer topLevelInjection(Integer topLevelFunction(String someString), String topLevelValue){
   				return topLevelFunction(topLevelValue);
     	}
   		Integer injectionResult=Depin(dependencyDeclarations).inject(`topLevelInjection`);
   		
"""
module herd.depin.core "1.0.0" {
	
	shared import ceylon.logging "1.3.3";
	shared import ceylon.collection "1.3.3";
	import herd.type.support "0.2.0";
}
