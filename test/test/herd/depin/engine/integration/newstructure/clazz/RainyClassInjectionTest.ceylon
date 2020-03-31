import ceylon.test {

	testExtension,
	test,
	assertThatException
}
import depin.test.extension {

	LoggingTestExtension
}
import test.herd.depin.engine.integration.newstructure.clazz.dependency {
	AbstractClassDependency
}
import herd.depin.core {
	Depin,
	FactorizationError
}
import ceylon.language.meta.model {
	ClassModel
}

testExtension (`class LoggingTestExtension`)
shared class RainyClassInjectionTest() {
	
	Boolean factorizationError(ClassModel<Throwable> error) {
		return error == `FactorizationError`;
	}
	
	shared test void whenProvidedAbstractClassDeclarationAsDependency_then_shouldFailFast(){
		assertThatException(()=>Depin({`class AbstractClassDependency`}))
				.hasType(factorizationError);
	}
	
	
}