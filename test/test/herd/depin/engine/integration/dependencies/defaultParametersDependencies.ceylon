import test.herd.depin.engine.integration.model {
	fixture
}
import herd.depin.engine {
	dependency
}
shared dependency String nonDefault=fixture.defaultParameter.nonDefault;


shared dependency String defaultedByFunction(String defaulted=fixture.defaultedParameterByFunction.param){
	return defaulted;
}
