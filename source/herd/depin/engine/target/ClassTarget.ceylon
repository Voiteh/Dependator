import ceylon.language.meta.model {
	Class,
	CallableConstructor,
	ValueConstructor
}

import herd.depin.api {
	Target,
	Dependency
}

class ClassTarget(Class<Object> clazz) extends Target(clazz) {
	
 shared actual Object inject(Injector injector, Dependency.Provider provider) {
		switch (constructor = targetConstructor)
		case (is CallableConstructor<Object>) {
			value parameters=declarationParameters(constructor.declaration.parameterDeclarations,provider);
			return safe(constructor.apply)([*parameters])
			((Exception cause) => Error.parameters(constructor.declaration,parameters,cause))
			;
		}
		case (is ValueConstructor<Object>) {
			return safe(constructor.get)([])((Exception cause) => Error(constructor.declaration,cause));
		}
		else {
			throw Exception("Unsupported constructor ``constructor``");
		}
	}
}
