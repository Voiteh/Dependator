
import ceylon.language.meta {
	type
}
import ceylon.language.meta.declaration {
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

shared class CollectorDependency(
	FunctionOrValueDeclaration declaration, 
	TypeIdentifier types,
	TypeIdentifier collectedTypes,
	Tree tree) extends Dependency(declaration,types){

	[Object*] collectingTuple(Anything first,Anything[] rest){
		if(exists first){
			return Tuple(first,collectingTuple(rest.first, rest.rest));
		}
		return empty;
	}


	shared actual Anything resolve {
		
		{Dependency*} collecting;
		log.trace("Collecting, by type ``collectedTypes``");
		if(declaration.annotated<SubtypeAnnotation>()){
			assert(is OpenType collectedTypes);
			collecting=tree.getSubTypeOf(collectedTypes);
		}else{
			collecting = tree.getAllByIdentifier(collectedTypes);
			
		}
		log.trace("Resolving ``collecting``, by type ``collectedTypes``");
		value collected = collecting.collect((Dependency element) => element.resolve);
		log.debug("Collected ``collected``, by type ``collectedTypes``");
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