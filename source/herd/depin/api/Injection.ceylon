import ceylon.language.meta.model {
	ClassModel,
	FunctionModel,
	Gettable
}


shared alias Injectable<Type=Anything>  => ClassModel<Type>|Gettable<Type>|FunctionModel<Type>;

shared abstract class Injection {
	

			
	shared static interface Injector{
		shared formal Type inject<Type>(Injectable<Type> clazz) ;
	}
	
	shared new () {
	}

	
	shared formal Anything inject;
	
	
	
	
}