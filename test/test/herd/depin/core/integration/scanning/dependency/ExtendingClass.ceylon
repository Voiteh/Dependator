import herd.depin.core {

	dependency
}
import test.herd.depin.core.integration.scanning {

	fixture
}
shared class ExtendingClass() extends BaseClass(fixture.name){
	shared dependency Integer age=fixture.age;
}