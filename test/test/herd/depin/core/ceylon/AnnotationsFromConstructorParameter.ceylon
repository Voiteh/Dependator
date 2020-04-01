import ceylon.test {
	test,
	ignore
}
shared class ConstructorTestClass{
	String param;
	shared new (String param){
		this.param = param;}
}

shared class AnnotationsFromConstructorParameter() {
	
	ignore
	shared test void shouldGetAnnotationsFromConstructorParameter(){
		assert (exists constructor = `class ConstructorTestClass`.defaultConstructor);
		assert(exists param=constructor.parameterDeclarations.first);
		assert(param.annotations<Annotation>().empty);
	}
	
	
}