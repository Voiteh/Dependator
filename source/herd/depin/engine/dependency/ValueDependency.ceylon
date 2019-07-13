import ceylon.language.meta.declaration {
	GettableDeclaration
}

import herd.depin.api {
	Dependency
}
import herd.depin.engine {

	log
}
shared class ValueDependency(GettableDeclaration declaration,
	Dependency.Definition definition,
	Dependency? container,
	{Dependency.Decorator*} decorators
) extends Dependency(definition,container,empty,decorators){
	shared actual Anything resolve {
		if(exists container, exists resolved=container.resolve){
			value memberGet = declaration.memberGet(resolved);
			log.debug("Resolved value member dependency ``memberGet else "null"`` for definition ``definition`` and container ``container``");
			return memberGet;
		}
		value get = declaration.get();
		log.debug("Registered value dependency ``get else "null"`` for definition ``definition```");
		return get;
	}
		
}