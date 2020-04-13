import ceylon.test {

	testExtension,
	assertThatException,
	test
}
import depin.test.extension {

	LoggingTestExtension
}
import herd.depin.core {

	Depin,
	FactorizationError
}
import test.herd.depin.core.integration.dependency {

	InterfaceDependency
}
import test.herd.depin.core.integration.newstructure.injection.clazz.dependency {

	AbstractClassDependency
}
import ceylon.language.meta.model {

	ClassModel
}

testExtension (`class LoggingTestExtension`)
shared class RainyInstantiationTest() {
	
	shared Boolean isFactorizationError(ClassModel<Throwable> error) {
		return error == `FactorizationError`;
	}
	shared test
	void whenProvidedFormalDepenedency_then_shouldThrowExceptionOnDepinInstantiation() {
		assertThatException(() => Depin({ `value InterfaceDependency.formalValue` })).hasType(isFactorizationError);
	}
	shared test void whenProvidedAbstractClassDeclarationAsDependency_then_shouldFailFast(){
		assertThatException(()=>Depin({`class AbstractClassDependency`}))
				.hasType(isFactorizationError);
	}
	
}