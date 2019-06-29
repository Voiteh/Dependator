import herd.depin.api {
	dependency
}

import test.herd.depin.engine.integration {
	fixture
}
import test.herd.depin.engine.integration.dependency {
	ExposingInterface
}
class UnsharedDependency() satisfies ExposingInterface{
	shared actual String exposed = fixture.unshared.exposed;
	
}

dependency ExposingInterface exposing=UnsharedDependency();