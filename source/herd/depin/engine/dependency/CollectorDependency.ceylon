import herd.depin.api {

	Dependency
}
import herd.depin.engine {
	log
}
import ceylon.language.meta.declaration {

	ValueDeclaration,
	OpenClassType,
	OpenType
}
import ceylon.language.meta.model {

	Class,
	Value
}
import ceylon.language.meta {

	type
}
shared class CollectorDependency(Dependency.Definition definition,Dependencies tree) extends Dependency(definition){

	shared actual Anything resolve {
		assert(is ValueDeclaration declaration=definition.declaration);
		assert(is OpenClassType collectorOpenType=declaration.openType);
		assert(exists OpenType collectedOpenType=collectorOpenType.typeArgumentList.first);
		value collecting = tree.getByType(collectedOpenType);
		log.trace("Collecting ``collecting``, by type ``collectedOpenType``");
		value collected = collecting.collect((Dependency element) => element.resolve);
		log.debug("Collected ``collected``, by type ``collectedOpenType``");
		
		Anything collector;
		
		if(exists container){
			assert(is Object resolvedContainer=container.resolve);
			value bound=declaration.memberApply<>(type(resolvedContainer)).bind(resolvedContainer);
			assert(is Class<> collectorType=bound.type);
			collector=collectorType.apply(collected);
		}else{
			assert(is Class<> collectorType= declaration.apply<>().type);	
			collector=collectorType.apply(collected);
		}
		return collector;
	}
	
}