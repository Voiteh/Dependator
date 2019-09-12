

import test.herd.depin.engine.integration {
	fixture
}
import herd.depin.core {

	dependency
}
shared object dependencyHolder{
	shared dependency String innerObjectDependency=fixture.objectDependencies.innerObjectDependency;
}