import ceylon.language.meta.declaration {
	NestableDeclaration,
	FunctionDeclaration
}

import herd.depin.api {
	Dependency,
	Definition
}

shared class FunctionDependency(FunctionDeclaration declaration, Definition definition) extends Dependency(declaration, definition) {
	shared actual Anything provide(Provider provider) {
		value parameters = declarationParameters(declaration.parameterDeclarations, provider);
		if (is NestableDeclaration containerDeclaration = declaration.container) {
			assert (exists container = provider.provide(containerDeclaration));
			return safe(declaration.memberInvoke)([container, [], *parameters])
			((Exception cause) => Error.memberParameters(declaration, container, parameters, cause));
		}
		return safe(declaration.invoke)([[],*parameters])((Exception cause) => Error.parameters(declaration,parameters,cause));
	}
}
