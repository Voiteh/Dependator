"""
   This is core module, for dependency injection framework Depin. 
   Whole concept of this framework, is based on [[Dependency]] class and [[Injection]] interface. 
   Both are tightly coupled togather. 
   The [[Dependency]] class is wrapped ceylon declaration, with additional information like [[Identification]],
   providing ability to clearly identify what to inject in [[Injection]].
   [[Dependency]] is identified by it's name and declaration open type. 
   From point of view of [[Injection]], two declaration (and after provisioning [[Dependency]]) having same name,
   (for example from different packages), with different open types are not coliding. 
   [[Dependency]] has also ability to be resolved.
   Resolvance process is executed via [[Dependency.resolve]] attribute, this is done every time dependency has been identified and being injected.
   To cache resolvance there are [[Dependency.Decorator]]s which can be applied, furtherly described.
   [[Injection]] is process of resolving dependencies (container and parameters) and calling requested constructor method or getting value.   
        
   To use this framework, one need to first provide dependencies, for further injection. 
   It is done using [[scanner]] object. Scanning is gathering of  and value declaration annotated with [[DependencyAnnotation]].
   
   They can be nested in classes and member classes or top level, any formal declaration will be rejected. 
   The [[scanner.scan]] call would provide declarations for further use. This function, takes [[Scope]]s as paremeters.
   [[Scope]] is range on which scanning would execute. When declaration are allready scaned they can be used for,   [[Depin]] class object creation. 
   [[Depin]] will convert declarations into [[Dependency]]'ies  and provide [[Depin.inject]] method.
   Now the injection can happen. [[Depin.inject]] requires [[Injectable]] parameter which is alias for class, function or value model to which injection will happen. 
   Attributes and methods needs to be bound to container object first.

   Example:
   		
   		shared dependency String topLevelValue="some value";
   		shared dependency Integer topLevelFunction(String someString) => someString.size;
   
   		shared Integer topLevelInjection(Integer topLevelFunction(String someString), String topLevelValue){
   			return topLevelFunction(topLevelValue);
   		}
   		//run
   		shared void moduleDocs() {
   			value depedencencyDeclarations=scanner.scan({`module`});
   			value result=Depin(depedencencyDeclarations).inject(`topLevelInjection`);
   			assert(topLevelValue.size==result);
   		}
   		
"""
module herd.depin.core "0.0.0" {
	
	shared import ceylon.logging "1.3.3";
	shared import ceylon.collection "1.3.3";
	import herd.type.support "0.2.0";
}
