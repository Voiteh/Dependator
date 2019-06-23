
import test.herd.depin.engine.integration.model {
	fixture
}
import herd.depin.api {
	dependency
}
shared dependency String name=fixture.person.john.name;
shared dependency Integer age=fixture.person.john.age;