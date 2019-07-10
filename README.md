# Depin
Dependency injection framework for Ceylon

This is mimimalistic framework which should allow, injection of declared dependencies into provided model. There are two main concets which needs to be understood. 

## Injection and dependency

Injection is execution of resolvance of declared dependencies, into values and functions and providing them into constructors or initializers, used as target for the injection. The resolvance of dependency is process of making declaration fully initialized object. Dependency is an object included into `Depin` identified by declaration of value or function and it's annotations

### Definition

To define a depedency `DepndencyAnnotation` is used. Function or value declaration can be annotated with this annotation. A Dependecy has it's declaration and definition. Declaration is a Ceylon declartion (location of specific dependecy in class graph), and definition is is an object comosed of `OpenType`, of declared dependency and it's control annotations. Control annotations provides ability to identify an annotation uniquely. By default dependency is identified by name of it's declaration. Two dependencies with different type and the same name are treated as unique. 

