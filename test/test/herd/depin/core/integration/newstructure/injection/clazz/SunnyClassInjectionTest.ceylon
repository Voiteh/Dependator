import ceylon.test {
	testExtension,
	test
}
import depin.test.extension {

	LoggingTestExtension
}
import test.herd.depin.core.integration.newstructure.injection.clazz.injection {

	NestedClassInjection,
	ClassWithTargetConstructorInjection
}
import test.herd.depin.core.integration.newstructure.injection.clazz.dependency {
	DerivedClassDependency,
	something,
	nonDefault
}
import herd.depin.core {

	Depin
}

import test.herd.depin.core.integration.injection {

	ClassWithDefaultedInitializerParameter,
	ClassWithDefaultedParameterFunctionInjection
}
testExtension (`class LoggingTestExtension`)
shared class SunnyClassInjectionTest() {
	
	
	
	shared test void whenProvidedConcreteClassDependencyWithItsDepdendencies_then_shouldInjectItToClassInjection(){
		value inject = Depin({`class DerivedClassDependency`,`value fixture.classParam`})
		.inject(`NestedClassInjection`);
		assert(inject.derivedClassDependency.classParam==fixture.classParam);		
	}
	shared test void whenProvidedNonDefaultParameterDependency_then_shouldInjectItIntoClassWithDefaultedParameter(){
			value result = Depin({`value nonDefault`}).inject(`ClassWithDefaultedInitializerParameter`);
			assert(result.defaultedParameter ==fixture.defaultParameter.text);
			assert(result.nonDefault ==fixture.defaultParameter.nonDefault);
		
	}
	
	shared test void whenProvidedNoDependecies_then_shouldInjectClassWithDefaualtedParameter(){
		assert(Depin().inject(`ClassWithDefaultedParameterFunctionInjection`).defaultedFunction()
			==fixture.defaultedParameterFunction.param);
	}
	shared test void whenProvidedDependency_shouldInjectTargetedConstructorToClassWithTwoConstructors(){
		assert(Depin({`value something`}).inject(`ClassWithTargetConstructorInjection`).something
			==fixture.targetWithTwoCallableConstructors.param.reversed);
	}
}