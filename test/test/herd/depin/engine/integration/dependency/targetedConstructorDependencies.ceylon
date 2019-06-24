import test.herd.depin.engine.integration.target {
	fixture
}

import herd.depin.api {
	dependency
}
shared dependency String something =fixture.targetWithTwoCallableConstructors.param;