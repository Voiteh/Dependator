

import test.herd.depin.core.integration {
	fixture
}
import test.herd.depin.core.integration.dependency {
	ExposingInterface
}
import herd.depin.core {

	dependency
}
class UnsharedDependency() satisfies ExposingInterface{
	shared actual String exposed = fixture.unshared.exposed;
	
}

dependency ExposingInterface exposing=UnsharedDependency();