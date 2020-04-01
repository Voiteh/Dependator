import ceylon.test {
	test
}
import test.herd.depin.core.poc.model {
	DefaultedClass
}
shared class DefaultedParameterTest() {
	
	shared test void shouldInstantiateDefaultedClassWithoutProvidedParameters(){
		value apply = `DefaultedClass`.apply();
		assert(apply.defaulted=="abc");
	}
	shared test void shouldInstantiateDefaultedClassWithoutProvidedParametersViaConstructor(){
		assert(exists constructor=`DefaultedClass`.defaultConstructor);
		value apply=constructor.apply();
		assert(apply.defaulted=="abc");
	}
	
	
	shared test void shouldInstantiateDefaultedClassWithoutProvidedParametersViaDeclaration(){
		value defaultConstructor = `class DefaultedClass`.defaultConstructor;
		assert(is DefaultedClass apply=defaultConstructor.invoke());
		assert(apply.defaulted=="abc");
	}
}