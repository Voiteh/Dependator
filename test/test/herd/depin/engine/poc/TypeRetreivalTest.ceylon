import ceylon.language.meta.model {
	Type
}
import ceylon.test {
	test
}

import test.herd.depin.engine.poc.model {
	parametrizedReturnType,
	Parametrized
}




shared class TypeRetreivalTest() {
	
	
	
	shared test void shouldRetreiveFullReturnType(){
		assert(is Type<Parametrized<String>>type = `function parametrizedReturnType`.apply<>().type);
		
	}
	
	
	
	
}