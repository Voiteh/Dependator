

import herd.depin.api {
	dependency
}
import test.herd.depin.engine.integration {
	fixture
}
shared dependency String nonDefault=fixture.defaultParameter.nonDefault;


shared dependency String defaultedByFunction(String defaulted=fixture.defaultedParameterByFunction.param){
	return defaulted;
}
