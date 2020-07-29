import ceylon.test {
	testExtension,
	test
}
import depin.test.extension {
	LoggingTestExtension
}
import test.herd.depin.core.integration.injection.\ivalue.dependency {
	concreteAbstractClassValue,
	extractingContextualDependency
}
import herd.depin.core {
	Depin
}
import test.herd.depin.core.integration.injection.\ivalue.injection {
	abstractClassValueInjection,
	contextualValueInjection,
	contextualExtractingInjection
}
shared class SunnyInjectionTest() {
	
	shared test void whenProvidedConcreteAbstractDependency_then_shouldInjectIt(){
		value inject = Depin({`value concreteAbstractClassValue`})
		.inject(`abstractClassValueInjection`);
		assert(inject==concreteAbstractClassValue);
	}
	
	shared test void whenInjectionParameterIsContextual_then_shouldInjectItWithContext(){
		String result = Depin({}).inject(`contextualValueInjection`, fixture.contextual.parameter);
		assert(result==fixture.contextual.parameter);
	}
	
	shared test void whenProvidedRequiredContextualDependency_then_shouldInjectItUsingContext(){
		Integer result=Depin({`function extractingContextualDependency`})
				.inject(`contextualExtractingInjection`,fixture.contextual.parameter);
		assert(result==fixture.contextual.parameter.size);
	}
	
	
}