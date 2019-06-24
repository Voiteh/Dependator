import test.herd.depin.engine.integration.target {
	fixture
}

import herd.depin.api {
	dependency
}
shared dependency Integer nesting =fixture.nesting.nesting;
shared dependency Integer nested =fixture.nesting.nested;