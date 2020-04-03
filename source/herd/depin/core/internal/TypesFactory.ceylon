import ceylon.language.meta.declaration {
	NestableDeclaration,
	FunctionalDeclaration,
	FunctionOrValueDeclaration,
	FunctionDeclaration,
	ValueDeclaration
}

import herd.depin.core.internal.dependency {
	FunctionalOpenType,
	TypeIdentifier
}
import herd.depin.core {
	FactoryAnnotation
}

shared class TypesFactory() {
	
	shared TypeIdentifier create(NestableDeclaration declaration) {
		if (is FunctionOrValueDeclaration declaration, declaration.parameter) {
			switch (declaration)
			case (is FunctionDeclaration) {
				return FunctionalOpenType {
					returnType = declaration.openType;
					parameters = declaration.parameterDeclarations.collect((FunctionOrValueDeclaration element) => create(element));
				};
			}
			case (is ValueDeclaration) {
				return declaration.openType;
			}
		} else if (declaration.annotated<FactoryAnnotation>()) {
			return declaration.openType;
		}
		switch (declaration)
		case (is FunctionalDeclaration) {
			return FunctionalOpenType {
				returnType = declaration.openType;
				parameters = declaration.parameterDeclarations.collect((FunctionOrValueDeclaration element) => create(element));
			};
		}
		else {
			return declaration.openType;
		}
	}
}
