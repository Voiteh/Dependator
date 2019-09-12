

import test.herd.depin.engine.integration {
	fixture
}
import test.herd.depin.engine.integration.dependency {
	ExposingInterface
}
import herd.depin.core {

	dependency
}
class UnsharedDependency() satisfies ExposingInterface{
	shared actual String exposed = fixture.unshared.exposed;
	
}

dependency ExposingInterface exposing=UnsharedDependency();