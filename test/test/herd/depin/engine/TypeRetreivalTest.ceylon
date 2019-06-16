import test.herd.depin.engine.model {
	Parametrized
}
import ceylon.test {
	test
}
import ceylon.language.meta.model {
	Type
}




shared class TypeRetreivalTest() {
	
	
	
	shared test void shouldRetreiveFullReturnType(){
		assert(is Type<Parametrized<String>>type = `function parametrizedReturnType`.apply<>().type);
		
	}
	
	
	
	
}