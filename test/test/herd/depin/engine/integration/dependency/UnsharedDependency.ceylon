import test.herd.depin.engine.integration.target {
	fixture
}
import herd.depin.api {
	dependency
}
class UnsharedDependency() satisfies ExposingInterface{
	shared actual String exposed = fixture.unshared.exposed;
	
}

dependency ExposingInterface exposing=UnsharedDependency();