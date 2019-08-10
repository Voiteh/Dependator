 import ceylon.language.meta {
	resolve=type
}
import ceylon.language.meta.declaration {
	NestableDeclaration,
	FunctionOrValueDeclaration
}

import herd.depin.engine {
	log
}
import herd.type.support {
	flat
}
import herd.validx {
	invalidate=validate,
	Single
}


 void typeConstrain(NestableDeclaration? validDeclaration, Anything val) {
 	log.debug("Validating type constraint for ``val else "null"`` against ``validDeclaration?.openType else "null"``");
	if (exists validOpenType=validDeclaration?.openType) {
		value valOpenType = resolve(val).declaration.openType;
		value typeSequence = flat.openTypes(valOpenType).sequence();
		log.trace("Type sequence for ``val else "null"`` is ``typeSequence``");
		if(!typeSequence.contains(validOpenType)){
			throw Exception("Type mismatch ``val else "null"`` is not of ``validOpenType``");
		}
		
	} else if (exists val) {
		throw Exception("Type mismatch no type for declaration but value has been provided ``val`` ");
	}
}
shared class Validator( NestableDeclaration? containerDeclaration = null, FunctionOrValueDeclaration[] parameterDeclarations = []) {

	
	shared void validate(Anything container, Anything[] parameters=empty) {
		value parametersValidations = zipPairs(parameterDeclarations, parameters)
				.collect(([FunctionOrValueDeclaration, Anything] element) => Single(`typeConstrain`, [*element]));
		invalidate {
			Single(`typeConstrain`, [containerDeclaration, container]) ,
			*parametersValidations
		};
	}
}
