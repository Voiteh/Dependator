import test.herd.depin.core.integration.injection.clazz {

	fixture
}
shared object dependencyHolder{
	shared String innerObjectDependency=fixture.objectDependencies.innerObjectDependency;
}