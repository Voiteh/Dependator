import ceylon.test {
	test
}

import test.herd.depin.engine.poc.model {
	parametrizedReturnType,
	Parametrized,
	fixtures
}





		
shared class InvocationTest() {
	
	shared test void shouldInstantiateParametrizedTypeUsingFunction(){
		assert(is Parametrized<String> invoke = `function parametrizedReturnType`.invoke());
		
		assert(fixtures.parametrzied.strParametrized==invoke);

	}
	shared test void shouldInstantiateParametrizedTypeUsingCallableConstructor(){
		assert(is Parametrized<String> invoked=`class Parametrized`.defaultConstructor.invoke([`String`],"abc"));
		assert(fixtures.parametrzied.strParametrized==invoked);
	}
	
	
	
	
	
}