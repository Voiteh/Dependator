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

	contextualValueInjection
}
import ceylon.language.meta.model {

	ClassModel
}
shared class RainyValueInjectionTest() {
	
	
	shared test void whenInjectionParameterIsContextual_then_shouldThrowWithoutContext(){
	assertThatException(()=> Depin({}).inject(`contextualValueInjection`))
			.hasType((ClassModel<Throwable> error) => error==`Injection.Error`);

	}
	
}