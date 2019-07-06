import herd.depin.api {
	dependency,
	singleton
}

import test.herd.depin.engine.integration {
	fixture
}
shared variable Boolean change=fixture.changing.initial;
shared singleton dependency Boolean singletonDependency() => change;
shared dependency Boolean prototypeDependency()=>change;