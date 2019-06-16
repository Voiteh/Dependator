import ceylon.language.meta.declaration {
	FunctionDeclaration,
	NestableDeclaration,
	Package,
	FunctionOrValueDeclaration
}
import herd.depin.api {
	Injection,
	Provider
}
import ceylon.language.meta {
	type
}
import ceylon.language.meta.model {
	Function
}

shared class FunctionInjection(FunctionDeclaration declaration) extends Injection() {
	
	shared actual Anything provide(Provider provider) {
		if (!declaration.typeParameterDeclarations.empty) {
			throw Error("Paremetrized functions not supported yet");
		}
		value parameters = declaration.parameterDeclarations.map((FunctionOrValueDeclaration element) => provider.provide(element));
		Function<> fun;
		switch (declarationContainer = declaration.container)
		case (is NestableDeclaration) {
			assert (is Object container = provider.provide(declaration));
			fun = reThrow(() => declaration.memberApply(type(container)).bind(container), "Couldn't provide function ``declaration``");
		}
		case (is Package) {
			fun = reThrow(() => declaration.apply<>(), "Couldn't provide function ``declaration``");
		}
		return reThrow(()=>fun.apply(parameters),"Couldn't provide function ``declaration``");
	}
}