


import test.herd.depin.core.integration {
	fixture
}
import herd.depin.core {

	dependency
}
shared dependency String nonDefault=fixture.defaultParameter.nonDefault;


shared dependency String defaultedByFunction(String defaulted=fixture.defaultedParameterByFunction.param){
	return defaulted;
}
