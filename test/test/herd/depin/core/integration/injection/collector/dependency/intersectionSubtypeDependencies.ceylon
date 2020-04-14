import test.herd.depin.core.integration.injection.collector {
	fixture
}
shared object intersectionSubtypeDependencies{
	shared Integer one=fixture.ints.one;
	shared Integer two=fixture.ints.two;
	shared Integer three=fixture.ints.three;
}