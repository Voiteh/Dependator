import ceylon.language.meta.model {
	ClassModel
}
shared interface Injector {
	
	shared formal Type inject<Type>(ClassModel<Type> clazz) given Type satisfies Object;
	
	
}