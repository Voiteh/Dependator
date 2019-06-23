import test.herd.depin.engine.integration.model {
	fixture
}

import herd.depin.api {
	dependency
}
shared dependency Integer nesting =fixture.nesting.nesting;
shared dependency Integer nested =fixture.nesting.nested;