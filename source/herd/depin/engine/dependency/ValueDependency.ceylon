import ceylon.language.meta.declaration {
	GettableDeclaration
}

import herd.depin.api {
	Dependency
}
shared class ValueDependency(GettableDeclaration declaration,
	Dependency.Definition definition,
	Dependency? container,
	{Dependency.Decorator*} decorators
) extends Dependency(definition,container,empty,decorators){
	shared actual Anything resolve {
		if(exists container, exists resolved=container.resolve){
			return declaration.memberGet(resolved);
		}
		return declaration.get();
	}
		
}