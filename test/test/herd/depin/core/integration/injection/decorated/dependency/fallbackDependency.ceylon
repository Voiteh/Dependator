
import herd.depin.core {

	fallback
}
import test.herd.depin.core.integration.injection.decorated {

	fixture
}
shared fallback String fallbackDependency=fixture.fallback.val;