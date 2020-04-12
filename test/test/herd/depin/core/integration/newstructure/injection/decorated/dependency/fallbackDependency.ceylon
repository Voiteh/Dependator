
import test.herd.depin.core.integration {

	fixture
}
import herd.depin.core {

	fallback,
	dependency
}
shared fallback String fallbackDependency=fixture.dependencies.fallback;