import herd.depin.api {

	dependency,
	fallback
}
import test.herd.depin.engine.integration {

	fixture
}
shared fallback dependency String fallbackDependency=fixture.dependencies.fallback;