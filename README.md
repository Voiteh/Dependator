  

Depin - Dependency injection framework for Ceylon


All examples in this code can be found in `example` source directory of this repository

# Core 
"""   
   Depin Core - Dependency injection framework core module for Ceylon
   
   ## Logging
   This module uses standard Ceylon logging defined via `module ceylon.logging`. Configuration of logging may be altered using [[log]] value. 
   Whole module uses [[log]] for logging purpose.
   Reference to `module ceylon.logging` documentation for more information. 
   
   
   # Introduction 
   Whole concept of this framework, is based on [[Dependency]] and [[Injection]] abstract classes. 
   Both are tightly coupled together. 
   The [[Dependency]] class is different view on Ceylon declaration. 
   Dependencies are identified by name and declaration type. Functional dependency type identification contains:
   - return type of function 
   - parameter types (parameter names doesn't matter).
   To inject dependency both type and name must match in lookup phase.   
  
   From point of view of `Injection`, two declaration (and after provisioning [[Dependency]]) having same name,
   (for example from different packages), with different open types are not colliding.  
   
   
   ## Depin instantiation 
   To perform dependency injection [[Depin]] class object needs to be instantiated. It takes a stream of ceylon declarations as an arguments.
   Using those declarations dependencies will be provided. It is possible to provide stream manually but it is cumbersome in most cases.
         
   
   ### Declaration scanning
   For this purpose [[scanner]] object is available. Currently (0.2.0) scanning of declarations may be performed in various ways.
   [[scanner.dependencies]] method gives ability to scan provided [[Scope]]s in search of all declaration annotated with [[dependency]] annotation. 
   
   [[scanner.subtypeDependencies]] method give ability to scan provided [[Scope]]s in search of all declaration, which are subtype of provided type. 
   Only concrete classes are taken in consideration. 
   
   #### Scanning visibility
   Scanner will scan all classes and they members it doesn't matter either they are shared or not and if the packages condained in [[Scope]] are shared.
   
   ### Dependency provisioning 
   When declaration are provided to the [[Depin]] default constructor provisioning process occures. Declaration are turned into [[Dependency]]ies. 
   Validation of duplications is executed (no validation for circullar dependencies is in place right now). Then [[Dependency.Decorator]] are applied. 
   At the end of provisioning [[Depin]] will post an event [[Depin.ready]] for all [[Dependency.Decorator]]s so they can furtherly setup if needed. 
   
   ## Dependency lookup
   Whenver injection using [[Depin.inject]] or extraction [[Depin.extract]] are performed the lookup phase of [[Dependency]] must occur.
   Dependecies stored inside [[Depin]] are taken in consideration. There is no possibility to change what [[Dependency]] are stored in [[Depin]].
   Whenever it is required new instance of [[Depin]] should be created.
   Lookup phase takes in consideration name of dependency and it's type identifier. 
   
   
   ## Dependency resolution
   Resolution process is executed via [[Dependency.resolve]] attribute which provides a value or function that is beign used later in process, of injection or extraction.
   This is done every time dependency has been looked up and being injected or extracted.
   To cache resolution there are [[Dependency.Decorator]]s which can be applied, further described in this guide. 
   By default dependency resolution is lazy and not cached in any way.
   
   
   ## Dependency injection
   Executed via [[Depin.inject]], requires [[Injectable]] parameter which is alias for class, function or value model to which injection will happen.
   This process subjects: 
   - Dependency lookup
   - Dependency resolution
   - Calling function, or getting a value as a result of appling parameters to [[Injectable]] provided as parameter.
   
   Example:
   ```ceylon
   dependency String topLevelValue="some value";
   dependency Integer topLevelFunction(String someString) => someString.size;
   
   Integer topLevelInjection(Integer topLevelFunction(String someString), String topLevelValue){
   	   	return topLevelFunction(topLevelValue);
   }
   
   shared void run() {
   		value depedencencyDeclarations=scanner.dependencies({`package`});
   		value result=Depin(depedencencyDeclarations).inject(`topLevelInjection`);
   		print(result);
   }
   ```
   
   
   ## Dependency extraction (since 0.1.0)
   To provide easier interoperation with frameworks where programmer has no control, over creating objects such as Android SDK, [[Depin.extract]] functionality has been introduced. 
   It allows to provide resolved dependencies into the caller. So going with example of Android SDK, in `Activity.onCreate`, dependencies can be obtained by using correct naming and typing. 
   Then they can be bounded to `late` or `variable` fields and used in life-cycle of `Activity`. 
   Be aware that `Depin` does not provide any ability for disposing of these dependencies. 
   Although this can be achieved using dependency decorators and event handlers, notified through `Depin.notify` method. 
   It would vary by use-case, as each framework uses different interface for disposing. 
   
   Example:
   ```ceylon
   class UnaccesibleDependencyContainer(){
     suppressWarnings("unusedDeclaration")
     dependency String name="abc";
   }
   
   
   
   class Activity(){
     late String name;
   
     shared void onCreate(){
       //Used because can't obtain metamodel reference to local declaration: name value
       //top level values are obtainable
       assert(exists nameReference = `class Activity`.getDeclaredMemberDeclaration<ValueDeclaration>("name"));
       value dependencies = scanner.dependencies({`package`});
       name = Depin(dependencies).extract<String>(nameReference);
       assert(name=="abc");
       print(name);
     }	
   }
   shared void run(){
     Activity().onCreate();
   }
   
   ```
   
   ## Dependency visibility and encapsulation
   In this release Depin, does not honor Ceylon encapsulation in any way. Whatever is scanned, can be injected. This will be modified in further release. 
   
   ## Naming
   For some cases it is required to rename given [[Dependency]], for such requirements [[named]] annotation has been introduced. It takes [[String]] name as argument. 
   This hints [[Depin]] that [[Dependency]] created from this named declaration will have name as given in [[named.name]].
   
   Example:
   ```ceylon	
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
	   	scanner.dependencies({`package`});
	   }.inject(`printInjection`);
   }
   ```
   ### Warning ! 
   It is important to remember that to identify a dependency, it's type, must exactly match with declaration of type in injection. 
   So in given example `sum` is declared with `Integer?` type, `printInjection` first parameter has exactly the same type! 
   All intersection types, interfaces and unions must match exactly!
   
   ### Warning 2 ! 
   Because of https://github.com/eclipse/ceylon/issues/7448 it is not possible to rename (using [[named]] annotation) constructor parameters,
   for [[Dependency]] containers or injection constructor parameters.
   
   ## Targeting
   In some cases it is required to declare more than one constructor in a class. [[Depin]] won't be able to gues which constructor to use. 
   In this case [[target]] annotation can be used. This is applicable for injections and dependencies. 
   
   Example:
   ```ceylon
   
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
	  	 scanner.dependencies({`package`});
	   }.inject(`TargetedInjection.printInjection`);
   } 
   ```
   # Decorators 
   This framework uses concept of decorators defined via [[Dependency.Decorator]] interface. Each decorator is an annotation, 
   allowing to change way of dependency resolution. Example usage is to provide ability to define singletons or eager dependency resolvers.
   [[Dependency.Decorator]]s can be defined outside of this module, they are recognized during dependency provisioning from declarations.
   This feature in frameworks like Spring is called scopes. 
   Build in decorators: 
   -  Singleton - represented by `singleton` annotation,
   -  Eager  - represented by `eager` annotation,
   -  Fallback - represented by `fallback` annotation.
   
   More information can be found in specific annotation documentation.
   
   ## Handlers 
   Each decorator can be notified, from outside of framework, it needs just to implement [[Handler]] interface.
   This feature provides ability to change way decorators works.
   For example It allows to free up resources. To notify decorator [[Depin.notify]] method needs to be called. 
   
   # Collectors 
   [[Collector]] class is used for collecting of dependencies with specific open type.
   In this case naming doesn't matter. 
   [[Depin.inject]] will always inject whole known set of dependencies for given type declared in [[Collector.Collected]] type parameter.
   
   Example:
   ```ceylon
   dependency Integer one=1;
   dependency Integer two=2;
   
   void assertCollectorInjection(Collector<Integer> namingDoesntMatters){
   	   assert(namingDoesntMatters.collected.containsEvery({one,two}));
   }
   
   shared void run(){
	   Depin{
			   scanner.dependencies({`package`});
			   }.inject(`assertCollectorInjection`);
		   }
   } 
   ```
   
   ## Subtype collector (since 0.2.0)
   It is sometimes usefull to retreive whole set of object beign subtype of given type. [[subtype]] annotation has been introduced for this case.
   Whenver declaring injection with [[Collector]] parameter, annotated with [[subtype]] annotation, 
   [[Depin]] will know that You want all dependencies subtyping type parameter [[Collector.Collected]] and try to inject them.
   Union types and Intersection types are also taken in consideration. Results includes exact types of [[Collector]] type parameter. 
   
   Example:
   ```
   dependency Integer one=1;
   dependency Integer two=2;
   dependency String str="abc";
   dependency Float float=1.3;
   void assertSubtypeCollectorInjection(subtype Collector<Object?> namingDoesntMatters){
   	assert(namingDoesntMatters.collected.containsEvery({one,two,str,float}));
   }
   
   shared void run(){
   	Depin{
   		scanner.dependencies({`package`});
   	}.inject(`assertSubtypeCollectorInjection`);
   }

   ```
   
   # Interoperation with java
   Because of Java type-system definition, where generics are not part of the type declaration, [[Depin]] usage can be a bit of pain. 
   For cases, where there is no type parameters dependency injection should function without issues 
   but whenever generics are in place `<out Anything>`, type parameter declaration must be used.  
   
   Example:
   
   java class in native jvm module
   
   ```java
   
   public class Generic<T>{
	   private T data;
	   
	   public Generic(T data){
	   	   this.data=data;
	   }
	   
	   public T getData(){
	       return data;
	   }
	   @Override
	   public String toString(){
	   	   return data.toString();
	   }
   }
   
   ```
   dependencies declaration and usage in Ceylon
   
   
   ```ceylon
   dependency Generic<out Anything> data= Generic("data");
   
   suppressWarnings("uncheckedTypeArguments")
   shared Generic<String> injection(Generic<out Anything> data){
   	assert( is Generic<String> data  );
  	return data;
   }
   
   shared void run(){
   	value dependencies=scanner.dependencies({`package`});
	   value result=Depin(dependencies).inject(`injection`);
	   assert(result==data);
	   print(result);
   }
   ```   
