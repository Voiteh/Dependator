

import herd.depin.api {
	dependency
}
import test.herd.depin.engine.integration {
	fixture
}
shared dependency String something =fixture.targetWithTwoCallableConstructors.param;