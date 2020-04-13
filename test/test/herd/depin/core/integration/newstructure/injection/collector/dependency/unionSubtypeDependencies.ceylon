import test.herd.depin.core.integration.newstructure.injection.collector {

	Collected,
	fixture
}

shared object unionSubtypeDependencies{
	shared Collected one=fixture.collected.one;
	shared Collected two=fixture.collected.two;
	shared String three=fixture.strings.one;
	shared String four=fixture.strings.two;
}