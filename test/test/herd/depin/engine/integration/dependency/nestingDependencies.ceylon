


import test.herd.depin.engine.integration {
	fixture
}
import herd.depin.engine {

	dependency
}
shared dependency Integer nesting =fixture.nesting.nesting;
shared dependency Integer nested =fixture.nesting.nested;