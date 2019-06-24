import herd.depin.api {
	dependency
}
import test.herd.depin.engine.integration.target {
	fixture
}
shared dependency object dependencyHolder{
	shared dependency String innerObjectDependency=fixture.objectDependencies.innerObjectDependency;
}