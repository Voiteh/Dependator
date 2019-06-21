import herd.depin.engine {
	dependency
}
import test.herd.depin.engine.integration.model {
	fixture
}
shared dependency String name=fixture.person.john.name;
shared dependency Integer age=fixture.person.john.age;