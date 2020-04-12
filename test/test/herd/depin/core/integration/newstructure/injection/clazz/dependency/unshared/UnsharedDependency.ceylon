

import herd.depin.core {

	dependency
}
import test.herd.depin.core.integration.newstructure.injection.clazz.injection {

	Interface
}
import test.herd.depin.core.integration.newstructure.injection.clazz {
	fixture
}
class UnsharedDependency() satisfies Interface{
	shared actual String exposed = fixture.unshared.exposed;
	
}

dependency Interface exposing=UnsharedDependency();