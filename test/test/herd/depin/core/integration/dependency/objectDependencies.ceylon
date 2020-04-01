

import test.herd.depin.core.integration {
	fixture
}
import herd.depin.core {

	dependency
}
shared object dependencyHolder{
	shared dependency String innerObjectDependency=fixture.objectDependencies.innerObjectDependency;
}