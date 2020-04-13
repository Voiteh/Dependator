
import ceylon.test {

	assertThatException,
	test
}
import herd.depin.core {

	Depin
}

import test.herd.depin.core.integration.injection.collector.injection {
...
}
import test.herd.depin.core.integration.injection.collector.dependency {
	...
}
import test.herd.depin.core.integration.injection {
	BaseRainyInjectionTest
}


shared class RainyCollectorTest() extends BaseRainyInjectionTest() {
	
	
	shared test
	void whenProvidedSupertypeDependencies_then_shouldNotInjectThemIntoCollector() {
		assertThatException(() => Depin({
			`value fixture.collectable.one`,
			`value fixture.collectable.two`
		}).inject(`SubtypeCollectedInjection`)
	).hasType(isInjectionError);
}
	
	
}