import ceylon.language.meta.model {
	ClassModel
}




shared abstract class Injection {
	

			
	shared static interface Injector{
		shared formal Type inject<Type>(ClassModel<Type> clazz) given Type satisfies Object;
	}
	
	shared new () {
	}

	
	shared formal Object inject;
	
	
	
	
}