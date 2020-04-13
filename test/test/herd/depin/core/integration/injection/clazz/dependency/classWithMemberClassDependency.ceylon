import test.herd.depin.core.integration.injection.clazz {
	fixture
}

shared Integer nesting=fixture.memberClass.nesting;
shared Integer nested=fixture.memberClass.nested;