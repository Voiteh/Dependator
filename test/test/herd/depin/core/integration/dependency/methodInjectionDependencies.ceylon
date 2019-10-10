import test.herd.depin.core.integration {

	fixture
}
shared Integer initializerDependency=fixture.dependencies.methodInjection.initializer;
shared Integer parameterDependency=fixture.dependencies.methodInjection.parameter;