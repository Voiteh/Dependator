import ceylon.test {

	testExtension,
	test,
	assertThatException
}
import depin.test.extension {

	LoggingTestExtension
}
import test.herd.depin.core.integration.injection.clazz.dependency {
	...
	
}
import test.herd.depin.core.integration.injection.clazz.injection {
	...
}
import herd.depin.core {
	Depin
}

import test.herd.depin.core.integration.injection {

	BaseRainyInjectionTest
}

testExtension (`class LoggingTestExtension`)
shared class RainyClassInjectionTest() extends BaseRainyInjectionTest(){
	
	
	
	
	shared test
	void whenMissingParentClassDependency_then_shouldThrowInjectionError() {
		assertThatException(() =>
			Depin({ `value nested` }).inject(`ClassWithMemberClassInjection.MemberClass`))
				.hasType(isInjectionError);
	}
	shared test
	void whenMissingNonDefaultParameter_then_shouldThrowInjectionError() {
		assertThatException(() =>
			Depin().inject(`ClassWithMemberClassInjection`))
				.hasType(isInjectionError);
	}
	
}