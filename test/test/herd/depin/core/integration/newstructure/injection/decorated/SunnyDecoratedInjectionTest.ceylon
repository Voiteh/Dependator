import ceylon.test {

	testExtension,
	test
}
import depin.test.extension {

	LoggingTestExtension
}
import herd.depin.core {

	Depin
}
import test.herd.depin.core.integration.newstructure.injection.decorated.dependency{
	...
}
import test.herd.depin.core.integration.newstructure.injection.decorated.injection{
	...
}
testExtension (`class LoggingTestExtension`)
shared class SunnyDecoratedInjectionTest() {
	
	
	shared test void whenProvidedFallbackDependency_then_shouldInjectItWhenGivenDependencyMissing(){
		assert(Depin({`value fallbackDependency`})
			.inject(`fallbackInjection`)==fixture.fallback.val);
	}
	
	
	
}