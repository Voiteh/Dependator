import test.herd.depin.core.integration.newstructure.injection.clazz {
	fixture
}
shared class ClassWithDefaultedInitializerParameter(
	shared String nonDefault,
	shared String defaultedParameter=fixture.defaultParameter.text
) {}

shared String nonDefault=fixture.defaultParameter.nonDefault;