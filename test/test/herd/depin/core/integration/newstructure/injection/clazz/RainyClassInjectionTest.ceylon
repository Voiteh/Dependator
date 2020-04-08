import ceylon.test {

	testExtension,
	test,
	assertThatException
}
import depin.test.extension {

	LoggingTestExtension
}
import test.herd.depin.core.integration.newstructure.injection.clazz.dependency {
	AbstractClassDependency,
	nested
	
}
import test.herd.depin.core.integration.newstructure.injection.clazz.injection {
	ClassWithMemberClassInjection
	
}
import herd.depin.core {
	Depin,
	FactorizationError,
	Injection
}
import ceylon.language.meta.model {
	ClassModel
}

testExtension (`class LoggingTestExtension`)
shared class RainyClassInjectionTest() {
	
	Boolean factorizationError(ClassModel<Throwable> error) {
		return error == `FactorizationError`;
	}
	
	Boolean isInjectionError(ClassModel<Throwable> error) {
		return error == `Injection.Error`;
	}
	shared test void whenProvidedAbstractClassDeclarationAsDependency_then_shouldFailFast(){
		assertThatException(()=>Depin({`class AbstractClassDependency`}))
				.hasType(factorizationError);
	}
	
	shared test
	void whenMissingParentClassDependency_then_shouldThrowInjectionError() {
		assertThatException(() =>
			Depin({ `value nested` }).inject(`ClassWithMemberClassInjection.MemberClass`))
				.hasType(isInjectionError);
	}
	
}