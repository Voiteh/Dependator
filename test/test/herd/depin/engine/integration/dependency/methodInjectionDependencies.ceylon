import test.herd.depin.engine.integration {

	fixture
}
shared Integer initializerDependency=fixture.dependencies.methodInjection.initializer;
shared Integer parameterDependency=fixture.dependencies.methodInjection.parameter;