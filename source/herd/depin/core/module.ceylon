"""
   
   This is core module, for dependency injection framework Depin. 
   
   # Introduction 
   Whole concept of this framework, is based on [[Dependency]] class and [[Injection]] interface. 
   Both are tightly coupled togather. 
   The [[Dependency]] class is wrapped ceylon declaration, with additional information like [[Identification]],
   providing ability to clearly identify what to inject in [[Injection]].
   [[Dependency]] is identified by it's name and declaration open type. 
   From point of view of [[Injection]], two declaration (and after provisioning [[Dependency]]) having same name,
   (for example from different packages), with different open types are not coliding. 
   [[Dependency]] has also ability to be resolved.
   
   ## Dependency resolution
   
   Resolution process is executed via [[Dependency.resolve]] function, this is done every time dependency has been identified and being injected.
   To cache resolvance there are [[Dependency.Decorator]]s which can be applied, furtherly described. 
   By default dependency resolution is lazy and  not cached in any way.
   
   ## Dependency injection
   
   [[Injection]] is process of resolving dependencies (container and parameters) and calling requested constructor method or getting value.   
   
   #Usage
   
   To use this framework, one need to first provide dependencies, for further injection. 
   It is done using [[scanner]] object. Scanning is gathering of  and value declaration annotated with [[DependencyAnnotation]].
   
   They can be nested in classes and member classes or top level, any formal declaration will be rejected. 
   The [[scanner.scan]] call would provide declarations for further use. This function, takes [[Scope]]s as paremeters.
   [[Scope]] is range on which scanning would execute. When declaration are allready scaned they can be used for,   [[Depin]] class object creation. 
   [[Depin]] will convert declarations into [[Dependency]]'ies  and provide [[Depin.inject]] method.
   Now the injection can happen. [[Depin.inject]] requires [[Injectable]] parameter which is alias for class, function or value model to which injection will happen. 
   
   Example:
   
   		dependency String topLevelValue="some value";
   		dependency Integer topLevelFunction(String someString) => someString.size;
   
   		Integer topLevelInjection(Integer topLevelFunction(String someString), String topLevelValue){
   			return topLevelFunction(topLevelValue);
   		}
   
   		shared void run() {
   			value depedencencyDeclarations=scanner.scan({`package`});
   			value result=Depin(depedencencyDeclarations).inject(`topLevelInjection`);
   			assert(topLevelValue.size==result);
   		}
   		
   ## Scanning Visibility
   
   Scanner will scan all classes and they members it doesn't matters either they are shared or not. It may be required to pass scopes which will be excluded in `scanner.scan`. 
   
   ## Dependency visibility and encapsulation
   In this release Depin, does not honor Ceylon encapsulation in any way. Whatever is scanned, can be injected. This will be modified in further release. 
   	   	
   ## Naming
   For some cases it is required to rename given [[Dependency]], for such requirements [[NamedAnnotation]] has been introduced. It takes [[String]] name as argument. 
   This hints [[Depin]] that [[Dependency]] created from this named declaration will have name as given in [[NamedAnnotation.name]].
   	
   Example:
   		
   	   	dependency Integer[] summable =[1,2,3];
   	   		class DependencyHolder(named("summable") Integer[] numbers){
   	   		named("integerSum") dependency 
   	   		Integer? sum = numbers.reduce((Integer partial, Integer element) => partial+element);
   	   	}
   	   
   	  	 void printInjection(Integer? integerSum){
   	   		print("Sum of summable is: ``integerSum else "null"``");
   	  	 }
   	   
   	   
   	 	  shared void run(){
   	   		Depin{
   	   			scanner.scan({`package`});
   	   		}.inject(`printInjection`);
   	   	}
   	
   ### Warning! 
   Beacause of https://github.com/eclipse/ceylon/issues/7448 it is not possible to name (using [[NamedAnnotation]]) constructor parameters,
   for [[Dependency]] containers or injection constructor parameters.
   
   ## Targeting
   In some cases it is required to declare more than one constructor in a class. [[Depin]] won't be able to gues which constructor to use. 
   In this case [[TargetAnnotation]] can be used. This is applicable for injections and dependencies. 
   
   Example:
   
        class TargetedInjection {
   
	   		String constructorName;
	   
	   		shared new(){
	   			constructorName="default";
	   		}
	   
	   		shared target new targetedConstructor(){
	   			constructorName="targeted";
	   		}
	   
	   
	   		shared void printInjection(){
	   			print("Selected construcotr was: ``constructorName``");
	   		}
   
   		}
   
   
   		shared void run(){
   			Depin{
   				scanner.scan({`package`});
   			}.inject(`TargetedInjection.printInjection`);
   		} 
   
   
   # Decorators 
   This framework uses concept of decorators defined via [[Dependency.Decorator]] interface. Each decorator is an annotation, 
   allowing to change way of dependency resolution. Example usage is to provide ability to define singletons or eager dependency resolvers.
   [[Dependency.Decorator]]s can be defined outside of this module, they are recognized during dependency creation from declarations.
   This feature in frameworks like Spring is called scopes. 
   Build in decorators: 
     -  Singleton - represented by [[SingletonAnnotation]]
     -  Eager  - represented by [[EagerAnnotation]]
     -  Fallback - represented by [[FallbackAnnotation]]
      
   More information can be found in specific annotation documentation.
   	
   ## Handlers 
   Each decorator can be notified, from outside of framework, it needs just to implement [[Handler]] interface.
   This feature provides ability to change way decorators works.
   For example It allows to free up resources. To notify decorator [[Depin.notify]] method needs to be called. 
   	 
   # Collectors 
   [[Collector]] class is used for collecting of dependencies with specific open type.
   In this case naming doesn't matters. 
   [[Depin]] will always inject whole known set of dependencies for given type declared in [[Collector]]'s `Collected` type parameter.
   	 
   Example:
        dependency Integer one=1;
   		dependency Integer two=2;
   			   
   		void assertCollectorInjection(Collector<Integer> namingDoesntMatters){
   			assert(namingDoesntMatters.collected.containsEvery({one,two}));
   		}
   			   
   		shared void run(){
   			Depin{
   			scanner.scan({`package`});
   			}.inject(`assertCollectorInjection`);
   		} 
   """

module herd.depin.core "0.0.0" {
	
	shared import ceylon.logging "1.3.3";
	shared import ceylon.collection "1.3.3";
	import herd.type.support "0.2.0";
}
