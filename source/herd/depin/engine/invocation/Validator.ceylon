import ceylon.language.meta {
	resolve=type
}
import ceylon.language.meta.declaration {
	NestableDeclaration,
	FunctionOrValueDeclaration,
	OpenUnion
}

import herd.validx {
	invalidate=validate,
	Single
}


 void typeConstrain(NestableDeclaration? validDeclaration, Anything val) {
	if (exists validDeclaration) {
		value valOpenType = resolve(val).declaration.openType;
		if (is OpenUnion union = validDeclaration.openType) {
			if (!union.caseTypes.contains(valOpenType)) {
				throw Exception("Type mismatch ``valOpenType`` is non of ``union`` ");
			}
		} else if (validDeclaration.openType != valOpenType) {
			throw Exception("Type mismatch ``valOpenType`` is not ``validDeclaration``");
		}
	} else if (exists val) {
		throw Exception("Type mismatch no type for declaration but value has been provided ``val`` ");
	}
}
shared class Validator( NestableDeclaration? containerDeclaration = null, FunctionOrValueDeclaration[] parameterDeclarations = []) {

	
	shared void validate(Anything container, Anything[] parameters=empty) {
		invalidate {
			Single(`typeConstrain`, [containerDeclaration, container]),
			*parameterDeclarations.product(parameters)
					.map(([FunctionOrValueDeclaration, Anything] element) => Single(`typeConstrain`, [*element]))
		};
	}
}
