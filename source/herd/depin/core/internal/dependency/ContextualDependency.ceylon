import herd.depin.core {
	Dependency
}
import ceylon.language.meta.declaration {
	NestableDeclaration,
	OpenType
}
import ceylon.language.meta {
	type
}
import herd.type.support {
	flat
}
import herd.depin.core.internal {

	Defaulted
}

shared class ContextualDependency(
	ParameterDependency parameter,
	TypeIdentifier identificationFactory(NestableDeclaration declaration)) extends Dependency(parameter.name, parameter.identifier,parameter.declaration) satisfies Exposing {
	shared actual Anything resolve(Anything context) {
		value declaration = type(context).declaration;
		value resolvedType = identificationFactory(declaration);
		if (is OpenType identifier, is OpenType resolvedType) {
			value contains = flat.openTypes(resolvedType).contains(identifier);
			if (contains) {
				return context;
			}
		} else if (is FunctionalOpenType identifier, is FunctionalOpenType resolvedType) {
			if(identifier==resolvedType){
				return context;
			}
		}
		else if(is DefaultedParameterDependency parameter){
			value defaulted=parameter.resolve(context);
			if(defaulted is Defaulted){
				return defaulted;
			}
		}
		throw Dependency.ResolutionError("Types does not match ``identifier`` and ``resolvedType`` !", null);
	}
	
	shared actual ParameterDependency exposed => parameter;
}
