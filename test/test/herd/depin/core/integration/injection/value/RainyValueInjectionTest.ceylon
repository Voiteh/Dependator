import ceylon.test {
	testExtension,
	test,
	assertThatException
}
import depin.test.extension {
	LoggingTestExtension
}
import herd.depin.core {
	Depin,
	Injection
}
import test.herd.depin.core.integration.injection.\ivalue.injection {
	contextualValueInjection,
	contextualExtractingInjection,
	contextualCollectorInjection
}
import ceylon.language.meta.model {
	ClassModel
}
import test.herd.depin.core.integration.injection.\ivalue.dependency {

	forCollector
}

shared class RainyValueInjectionTest() {
	
	shared test
	void whenInjectionParameterIsContextual_then_shouldThrowWithoutContext() {
		assertThatException(() => Depin({}).inject(`contextualValueInjection`))
			.hasType((ClassModel<Throwable> error) => error == `Injection.Error`);
	}
	
	shared test
	void whenDependencyIsContextualAndContextNotProvided_then_shouldThrow(){
		assertThatException(() => Depin({}).inject(`contextualExtractingInjection`))
				.hasType((ClassModel<Throwable> error) => error == `Injection.Error`);
	
	}
	
	shared test void whenInjectionParameterIsContextualAndColectorAndCollectableElementsProvided_then_shouldThrow(){
		assertThatException(() => Depin({`value forCollector`})
			.inject(`contextualCollectorInjection`))
				.hasType((ClassModel<Throwable> error) => error == `Injection.Error`);
		
	}
	
}
