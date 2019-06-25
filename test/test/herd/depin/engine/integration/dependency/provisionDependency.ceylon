import herd.depin.api {
	dependency,
	prototype
}
import test.herd.depin.engine.integration.target {
	fixture
}
shared variable Boolean change=fixture.changing.initial;
shared dependency Boolean singletonDependency() => change;
shared dependency(prototype) Boolean prototypeDependency()=>change;