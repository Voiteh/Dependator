

import herd.depin.api {
	dependency
}
import test.herd.depin.engine.integration {
	fixture
}
shared dependency String name=fixture.person.john.name;
shared dependency Integer age=fixture.person.john.age;