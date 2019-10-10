
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
	Dependency
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
		value collecting = tree.getByType(collectedOpenType);
		log.trace("Collecting ``collecting``, by type ``collectedOpenType``");
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
		throw Exception("No dependency for collection of ``collectedOpenType``");
	}
	
}