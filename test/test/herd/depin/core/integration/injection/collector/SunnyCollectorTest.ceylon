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

import test.herd.depin.core.integration.injection.collector.dependency {
	...
}
import test.herd.depin.core.integration.injection.collector.injection {
	...
}

testExtension (`class LoggingTestExtension`)
shared class SunnyCollectorTest() {
	
	shared test
	void whenProvidedDependenciesToBeCollected_then_shouldInjectCollectedDependenciesIntoCollector() {
		value depin = Depin({
				`value one`,
				`value two`,
				`value three`
			});
		value collector = depin.inject(`CollectorInjection`).collector;
		assert (collector.collected.containsEvery({
					fixture.numbers.one,
					fixture.numbers.two,
					fixture.numbers.three
				}));
	}
	
	shared test
	void whenProvidedAtLeastOneDependency_then_shouldInjectCollectableSubtypesCollector() {
		value subtype = Depin({
				`value collectedOne`,
				`value collectedTwo`
			}).inject(`SubtypeCollectorInjection`);
		assert (subtype.collector.collected.containsEvery({
					fixture.collected.one,
					fixture.collected.two
				}));
	}
	
	shared test
	void whenProvidedCollectableValues_then_shouldInjectSubtypeUnionTypeCollector() {
		value subtype = Depin({
				`value unionSubtypeDependencies.one`,
				`value unionSubtypeDependencies.two`,
				`value unionSubtypeDependencies.three`,
				`value unionSubtypeDependencies.four`
			}).inject(`SubtypeUnionCollectedInjection`);
		assert (subtype.collector.collected.containsEvery({
					fixture.collected.one,
					fixture.collected.two,
					fixture.strings.one,
					fixture.strings.two
				}));
	}
	
	shared test 
	void whenProvidedIntegerValues_then_shouldInjectSubtypeIntersectionTypeCollector(){
		value depin=Depin({
			`value intersectionSubtypeDependencies.one`,
			`value intersectionSubtypeDependencies.two`,
			`value intersectionSubtypeDependencies.three`
		});
		value collector=depin.inject(`SubtypeIntersectionCollectedInjection`).collector;
		assert(collector.collected.containsEvery({
			fixture.ints.one,
			fixture.ints.two,
			fixture.ints.three
		}));
	}
}
