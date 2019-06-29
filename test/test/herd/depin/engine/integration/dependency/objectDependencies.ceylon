import herd.depin.api {
	dependency
}

import test.herd.depin.engine.integration {
	fixture
}
shared object dependencyHolder{
	shared dependency String innerObjectDependency=fixture.objectDependencies.innerObjectDependency;
}