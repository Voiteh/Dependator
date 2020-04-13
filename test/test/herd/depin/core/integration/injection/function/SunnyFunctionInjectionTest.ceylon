import ceylon.test {
	testExtension,
	test
}
import depin.test.extension {
	LoggingTestExtension
}
import test.herd.depin.core.integration.injection.\ifunction.dependency {
...
}
import herd.depin.core {
	Depin
}
import test.herd.depin.core.integration.injection.\ifunction.injection {
	...
}

testExtension (`class LoggingTestExtension`)
shared class SunnyFunctionInjectionTest() {
	
	shared test void whenProvidedTopLevelFunction_then_shouldInjectItToInjection(){
		Depin({`function topLevelFunction`}).inject(`topLevelInjection`);
	}

	shared test void whenProvidedTopLevelDefaultedFunction_then_shouldInjectDefaultedParameterFromFunction(){
		Depin({`function topLevelFunctionWithParameter`}).inject(`topLevelInjectionForFunctionWithParameter`);
		
	}	
	
	shared test void whenProvidedFactoryFunction_then_shouldInjectItsResult(){
		Depin({`function someString`}).inject(`factoryInjection`);
	}
	
	shared test void shouldInjectIntoFunction(){
		assert(Depin({`value first `,`value second`}).inject(`summingFunction`)==fixture.attributes.first+fixture.attributes.second);
	}
}