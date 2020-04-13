
import ceylon.test {

	assertThatException,
	test
}
import herd.depin.core {

	Depin
}
import test.herd.depin.core.integration.newstructure {
	BaseRainyInjectionTest
}
import test.herd.depin.core.integration.newstructure.injection.collector.injection {
...
}
import test.herd.depin.core.integration.newstructure.injection.collector.dependency {
	...
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