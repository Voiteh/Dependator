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




shared interface Injection {
			
	shared static interface Injector{
		shared formal Type inject<Type>(Injectable<Type> clazz) ;
	}
	
	shared formal Anything inject;
	
	
	
	
}