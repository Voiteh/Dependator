# Depin
Dependency injection framework for Ceylon

This mimimalistic is framework which should allow, injection of declared dependencies into provided model. There are two main concets which needs to be understood. 

## Target and dependency

Theese two concepts are strongly connected and one can't be explained withouth another. Target is an object, which will be retreived after injection of it's dependencies. Dependency is required data which needs to be provided to be injected into target. For some targets, some other previously used targets becomes dependencies. 

### Definition

To define a depedency `DepndencyAnnotation` is used. Class or constructor declaration and class members may be marked with this annotation. Also classes and anonymous objects, which are not annotated but their members are, are treated as dependencies. A Dependecy has it's definition. This object is comosed of `OpenType` of declared dependency and it's control annotations. Control annotations provides ability to identify an annotation uniquely. By default dependency is identified by name of it's declaration. Two dependencies with different type and the same name are treated as unique. 

