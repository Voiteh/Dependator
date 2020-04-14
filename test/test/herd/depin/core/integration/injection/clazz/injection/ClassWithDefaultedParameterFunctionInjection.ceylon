import test.herd.depin.core.integration.injection.clazz {

	fixture
}
shared class ClassWithDefaultedParameterFunctionInjection(shared String defaultedFunction()=> fixture.defaultedParameterFunction.param) {}