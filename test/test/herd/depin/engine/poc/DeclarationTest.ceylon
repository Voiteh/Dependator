import ceylon.test {
	test
}

import herd.depin.api {
	DependencyAnnotation
}

import test.herd.depin.engine.poc.model {
	InitializerAnnotatedClass
}
shared class DeclarationTest() {
	
	
	shared test void shouldAnnotatedDefaultConstructorForInitilizer(){
		value clazz = `class InitializerAnnotatedClass`;
		assert(clazz.annotated<DependencyAnnotation>());
		assert(clazz.defaultConstructor?.annotated<DependencyAnnotation>() exists);
		
	}
	
	
}