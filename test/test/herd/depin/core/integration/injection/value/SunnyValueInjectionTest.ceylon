import ceylon.test {
	testExtension,
	test
}
import depin.test.extension {
	LoggingTestExtension
}
import test.herd.depin.core.integration.injection.\ivalue.dependency {
	concreteAbstractClassValue
}
import herd.depin.core {
	Depin
}
import test.herd.depin.core.integration.injection.\ivalue.injection {
	abstractClassValueInjection
}
testExtension (`class LoggingTestExtension`)
shared class SunnyInjectionTest() {
	
	shared test void whenProvidedConcreteAbstractDependency_then_shouldInjectIt(){
		value inject = Depin({`value concreteAbstractClassValue`})
		.inject(`abstractClassValueInjection`);
		assert(inject==concreteAbstractClassValue);
	}
}