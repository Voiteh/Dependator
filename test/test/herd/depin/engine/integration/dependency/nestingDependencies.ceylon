

import herd.depin.api {
	dependency
}
import test.herd.depin.engine.integration {
	fixture
}
shared dependency Integer nesting =fixture.nesting.nesting;
shared dependency Integer nested =fixture.nesting.nested;