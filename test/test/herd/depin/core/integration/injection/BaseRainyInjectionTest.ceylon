import ceylon.language.meta.model {

	ClassModel
}
import herd.depin.core {

	Injection,
	Dependency,
	FactorizationError
}
import ceylon.test {

	testExtension
}
import depin.test.extension {

	LoggingTestExtension
}

shared class BaseRainyInjectionTest() {
	
	shared Boolean isFactorizationError(ClassModel<Throwable> error) {
		return error == `FactorizationError`;
	}
	
	shared Boolean isInjectionError(ClassModel<Throwable> error) {
		return error == `Injection.Error`;
	}
	
	shared Boolean isResolutionError(ClassModel<Throwable> error) {
		return error == `Dependency.ResolutionError`;
	}
	
}