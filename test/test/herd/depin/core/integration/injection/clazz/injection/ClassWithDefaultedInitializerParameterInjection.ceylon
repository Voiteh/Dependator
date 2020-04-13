import test.herd.depin.core.integration.injection.clazz {

	fixture
}
shared class ClassWithDefaultedInitializerParameterInjection(
	shared String nonDefault,
	shared String defaultedParameter=fixture.defaultParameter.text
) {}