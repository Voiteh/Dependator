
import ceylon.language.meta {
	type
}
import ceylon.language.meta.declaration {
	OpenClassType,
	OpenType,
	FunctionOrValueDeclaration
}
import ceylon.language.meta.model {
	Class,
	MemberClass,
	Type
}

import herd.depin.core {
	log,
	Collector,
	Dependency,
	SubtypeAnnotation
}

class CollectorDependency(FunctionOrValueDeclaration declaration, Dependency.Definition definition,Dependencies tree) extends Dependency(declaration,definition){

	[Object*] collectingTuple(Anything first,Anything[] rest){
		if(exists first){
			return Tuple(first,collectingTuple(rest.first, rest.rest));
		}
		return empty;
	}


	shared actual Anything resolve {
		assert(is OpenClassType collectorOpenType=declaration.openType);
		assert(exists OpenType collectedOpenType=collectorOpenType.typeArgumentList.first);
		{Dependency*} collecting;
		log.trace("Collecting, by type ``collectedOpenType``");
		if(declaration.annotated<SubtypeAnnotation>()){
			collecting=tree.getSubTypeOf(collectedOpenType);
		}else{
			collecting = tree.getByType(collectedOpenType);
			
		}
		log.trace("Resolving ``collecting``, by type ``collectedOpenType``");
		value collected = collecting.collect((Dependency element) => element.resolve);
		log.debug("Collected ``collected``, by type ``collectedOpenType``");
		value closedType = collected.reduce((Anything partial, Anything element) {
			value elementType=type(element);
			if(is Type<>partial){
				return partial.union(elementType);
			}else{
				return type(partial).union(elementType);
			}
		});
		if(is Type<> closedType){
			value tuple=collectingTuple(collected.first, collected.rest);
			switch(closedType)
			case (is MemberClass<Object,Nothing>) {
				value clazz=closedType.bind(collected.first);
				assert(is Class<Object> collectorType = `class Collector`.apply<>(clazz));
				return collectorType.apply(tuple);
				
			}		
			else{
				assert(is Class<Object> collectorType = `class Collector`.apply<>(closedType));
				return collectorType.apply(tuple);
			}
			
		}
		throw Exception("There was no dependecy to be collected for ``declaration``");
	}
	
}