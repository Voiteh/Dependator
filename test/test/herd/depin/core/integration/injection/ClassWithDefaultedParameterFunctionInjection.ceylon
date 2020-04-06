import test.herd.depin.core.integration {
	fixture
}
shared class ClassWithDefaultedParameterFunctionInjection(shared String defaultedFunction()=> fixture.defaultedParameterFunction.param) {}