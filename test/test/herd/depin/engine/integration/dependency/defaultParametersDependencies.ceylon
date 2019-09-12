


import test.herd.depin.engine.integration {
	fixture
}
import herd.depin.core {

	dependency
}
shared dependency String nonDefault=fixture.defaultParameter.nonDefault;


shared dependency String defaultedByFunction(String defaulted=fixture.defaultedParameterByFunction.param){
	return defaulted;
}
