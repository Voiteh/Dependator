import ceylon.language.meta.declaration {
	NestableDeclaration,
	FunctionalDeclaration,
	FunctionOrValueDeclaration,
	OpenType,
	GettableDeclaration
}

import herd.depin.core.internal.dependency {
	FunctionalOpenType,
	TypeIdentifier
}

shared class TypesFactory() {
	

	shared FunctionalOpenType forFunctionalDeclaration(FunctionalDeclaration&NestableDeclaration declaration){
		return FunctionalOpenType {
			returnType = declaration.openType;
			parameters = declaration.parameterDeclarations.map((FunctionOrValueDeclaration parameter) => forDeclaration(parameter)).sequence();
		};
	}
	shared OpenType forGettableDeclaration(GettableDeclaration&NestableDeclaration declaration){
		return declaration.openType;
	}
	shared TypeIdentifier forDeclaration(NestableDeclaration declaration) {
		
		if (is FunctionalDeclaration declaration) {
			return forFunctionalDeclaration(declaration);
		}
		return declaration.openType;
	}
}
