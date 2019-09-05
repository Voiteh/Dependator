

import test.herd.depin.engine.integration {
	fixture
}
import test.herd.depin.engine.integration.dependency {
	ExposingInterface
}
import herd.depin.engine {

	dependency
}
class UnsharedDependency() satisfies ExposingInterface{
	shared actual String exposed = fixture.unshared.exposed;
	
}

dependency ExposingInterface exposing=UnsharedDependency();