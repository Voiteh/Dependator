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
	String name,
	TypeIdentifier types,
	FunctionOrValueDeclaration declaration,
	TypeIdentifier collectedType,
	Tree tree
) extends Dependency(name, types,declaration) {
	
	[Object*] collectingTuple(Anything first, Anything[] rest) {
		if (exists first) {
			return Tuple(first, collectingTuple(rest.first, rest.rest));
		}
		return empty;
	}
	
	shared actual Anything resolve {
		
		{Dependency*} collecting;
		log.trace("Collecting, by type ``collectedType``");
		if (declaration.annotated<SubtypeAnnotation>()) {
			assert (is OpenType collectedType);
			collecting = tree.getSubTypeOf(collectedType);
		} else {
			collecting = tree.getAllByIdentifier(collectedType);
		}
		log.trace("Resolving ``collecting``, by type ``collectedType``");
		value collected = collecting.collect((Dependency element) => element.resolve);
		log.debug("Collected ``collected``, by type ``collectedType``");
		if (collected.empty) {
			throw Exception("There was no dependecy to be collected for ``declaration``");
		}
		value closedType = collected.fold<Type<>>(type(collected.first))((Type<> partial, Anything current) => partial.union(type(current)));
		log.trace("Final Collected Element type is type: `` closedType``");
		value tuple = collectingTuple(collected.first, collected.rest);
		switch (closedType)
		case (is MemberClass<Object,Nothing>) {
			value clazz = closedType.bind(collected.first);
			assert (is Class<Object> collectorType = `class Collector`.apply<>(clazz));
			return collectorType.apply(tuple);
		}
		else {
			assert (is Class<Object> collectorType = `class Collector`.apply<>(closedType));
			return collectorType.apply(tuple);
		}
	}
}
