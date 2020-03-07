
import ceylon.language.meta {
	type
}
import ceylon.language.meta.declaration {
	ValueDeclaration,
	OpenClassType,
	OpenType
}
import ceylon.language.meta.model {
	Class,
	MemberClass
}

import herd.depin.core {
	log,
	Collector,
	Dependency,
	SubtypeAnnotation
}

class CollectorDependency(Dependency.Definition definition,Dependencies tree) extends Dependency(definition){

	[Object*] collectingTuple(Anything first,Anything[] rest){
		if(exists first){
			return Tuple(first,collectingTuple(rest.first, rest.rest));
		}
		return empty;
	}


	shared actual Anything resolve {
		assert(is ValueDeclaration declaration=definition.declaration);
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
		if(exists first=collected.first){
			value closedType=type(first);
			value tuple=collectingTuple(collected.first, collected.rest);
			switch(closedType)
			case (is Class<Object,Nothing>) {
				assert(is Class<Object> collectorType = `class Collector`.apply<>(closedType));
				return collectorType.apply(tuple);
			}
			else case (is MemberClass<Object,Nothing>) {
				value clazz=closedType.bind(first);
				assert(is Class<Object> collectorType = `class Collector`.apply<>(clazz));
				return collectorType.apply(tuple);
				
			}
			else{
				throw Exception("Unhandled collected type ``closedType``");
			}
			
		}
		throw Exception("There was no dependecy to be collected for ``declaration``");
	}
	
}