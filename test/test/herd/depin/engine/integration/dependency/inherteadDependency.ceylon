import test.herd.depin.engine.integration {

	fixture
}
import herd.depin.core {

	dependency
}
shared class BaseClass(
	shared dependency String name
){
	
}

shared class ExtendingClass() extends BaseClass(fixture.person.john.name){
	shared dependency Integer age=fixture.person.john.age;
}