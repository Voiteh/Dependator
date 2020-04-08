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
import test.herd.depin.core.integration.newstructure.injection.collector {
	fixture
}
import test.herd.depin.core.integration.newstructure.injection.collector.dependency {
	...
}
import test.herd.depin.core.integration.newstructure.injection.collector.injection {
	...
}
testExtension (`class LoggingTestExtension`)
shared class SunnyCollectorTest() {
	
	
	shared test void whenProvidedDependenciesToBeCollected_then_shouldInjectCollectedDependenciesIntoCollector(){
		value depin=Depin({
			`value one`,
			`value two`,
			`value three`
		});
		value collector=depin.inject(`CollectorInjection`).collector;
		assert(collector.collected.containsEvery({
			fixture.numbers.one,
			fixture.numbers.two,
			fixture.numbers.three
		}));
		
	}
	
	shared test void whenProvidedAtLeastOneDependency_then_shouldInjectCollectableSubtypesCollector(){
		value subtype=Depin({
			`value collectedOne`,
			`value collectedTwo`
		}).inject(`SubtypeCollectorInjection`);
		assert(subtype.collector.collected.containsEvery({
			fixture.collected.one,
			fixture.collected.two
		}));
	}
	
}