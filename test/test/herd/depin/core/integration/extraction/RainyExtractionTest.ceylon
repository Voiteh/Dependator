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
	Dependency
}
import ceylon.language.meta.model {

	ClassModel
}
late String name;
shared class RainyExtractionTest() {
	
	Boolean isResolutionError(ClassModel<Throwable> error) {
		return error == `Dependency.ResolutionError`;
	}
	
	shared test
	void whenMissingDependency_shouldThrowDependencyResolutionError_onExtraction() {
		assertThatException(() =>
			Depin().extract<String>(`value name`))
				.hasType(isResolutionError);
	}
	
}