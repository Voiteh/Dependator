import herd.depin.api {
	dependency,
	singleton,
	eager
}

import test.herd.depin.engine.integration {
	fixture,
	notified
}
shared variable Boolean change=fixture.changing.initial;
shared singleton dependency Boolean singletonDependency() => change;
shared dependency Boolean prototypeDependency()=>change;
shared eager Boolean eagerDependency() => change;
shared notified Boolean notifiedDependency= change;