

import test.herd.depin.engine.integration {
	fixture,
	notified
}
import herd.depin.core {

	eager,
	dependency,
	singleton
}
shared variable Boolean change=fixture.changing.initial;
shared singleton dependency Boolean singletonDependency() => change;
shared singleton dependency Boolean otherSingletonDependency()=> change;
shared dependency Boolean prototypeDependency()=>change;
shared eager Boolean eagerDependency() => change;
shared notified Boolean notifiedDependency= change;