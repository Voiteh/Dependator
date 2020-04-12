import test.herd.depin.core.integration.newstructure.injection.clazz {

	fixture
}
shared object dependencyHolder{
	shared String innerObjectDependency=fixture.objectDependencies.innerObjectDependency;
}