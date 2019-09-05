import ceylon.language.meta.model {
	ClassModel,
	FunctionModel,
	Gettable,
	Type
}
import ceylon.language.meta.declaration {

	NestableDeclaration,
	FunctionOrValueDeclaration
}
import herd.validx {

	invalidate=validate,
	Single
}
import herd.type.support {

	flat
}
import ceylon.language.meta {

	resolve=type
}


shared alias Injectable<Type=Anything>  => ClassModel<Type>|Gettable<Type>|FunctionModel<Type>;

void typeConstrain(Type<>? type, Anything val) {
	log.debug("[Validating] type constraint, for ``val else "null"``, against ``type else "null"``");
	if(exists type){
		if(!type.typeOf(val)){
			throw Exception("Type mismatch ``val else "null"`` is not of ``type``");
		}
	}else if(exists val){
		throw Exception("Type mismatch no type for declaration but value has been provided ``val`` ");
	}
}

//TODO make it an interface or refactor to proper abstract class 
shared abstract class Injection {
	shared static class Validator(Type<>? containerType=null,{Type<>*} parameterTypes=empty) {
		
		shared void validate(Anything container, Anything[] parameters=empty) {
			value parametersValidations = zipPairs(parameterTypes, parameters)
					.collect(([Type<>, Anything] element) => Single(`typeConstrain`, [*element]));
			invalidate {
				Single(`typeConstrain`, [containerType, container]) ,
				*parametersValidations
			};
		}
	}

	
			
	shared static interface Injector{
		shared formal Type inject<Type>(Injectable<Type> clazz) ;
	}
	

	shared new () {
	}


	
	shared formal Anything inject;
	
	
	
	
}