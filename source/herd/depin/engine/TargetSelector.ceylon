import ceylon.language.meta.declaration {
	ConstructorDeclaration,
	ClassDeclaration,
	Declaration
}

import herd.depin.api {
	TargetAnnotation
}
shared  class TargetSelector() {
	shared ConstructorDeclaration select(ClassDeclaration declaration) {
		ConstructorDeclaration[] annotated = declaration.constructorDeclarations().select((ConstructorDeclaration element) => element.annotated<TargetAnnotation>());
		if (exists selected = annotated.first) {
			if (annotated.rest.empty) {
				log.debug("Selected ``selected`` for declaration: ``declaration``");
				return selected;
			} else {
				throw Error {
					declaration = declaration;
					message = "Only one constructor may be annotated `` `class TargetAnnotation` ``, found: ``annotated``";
				};
			}
		} else if (exists default = declaration.defaultConstructor) {
			log.debug("Selected ``default`` for declaration: ``declaration``");
			return default;
		} else {
			throw Error {
				declaration = declaration;
				message = "Either single constructor must be annotated with `` `class TargetAnnotation` ``
				                        or default constructor must be defined, not both! Found: ``annotated``"; };
			}
		}

		
		shared class Error(Declaration declaration,String message,Throwable? cause=null) 
				extends Exception("[``declaration``] ``message``",cause){}
}