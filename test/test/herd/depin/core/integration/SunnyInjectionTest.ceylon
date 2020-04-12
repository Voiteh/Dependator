import ceylon.language.meta.declaration {
	ValueDeclaration,
	FunctionOrValueDeclaration
}
import ceylon.test {
	test,
	testExtension
}

import depin.test.extension {
	LoggingTestExtension
}

import herd.depin.core {
	Depin,
	DependencyAnnotation,
	scanner
}

import test.herd.depin.core.integration {
	fixture
}
import test.herd.depin.core.integration.dependency {
	...
}
import test.herd.depin.core.integration.injection {
	Person,
	DataSource,
	ClassWithDefaultedInitializerParameter,
	ClassWithDefaultedParameterFunctionInjection,
	ClassWithMemberClass,
	AnonymousObjectTarget,
	ClassWithInterfaceAttribute,
	functionInjection,
	MethodInjection,
	fallbackInjection,
	CollectorInjection,
	SubtypeCollectorInjection,
	SubtypeUnionCollectedInjection,
	SubtypeIntersectionCollectedInjection
}
import test.herd.depin.core.integration.newstructure.injection.clazz.injection {

	ClassWithTargetConstructorInjection
}


testExtension (`class LoggingTestExtension`)
shared class SunnyInjectionTest() {
	
	shared test void shouldInjectCollectableSubtypesCollector(){
		value subtype=Depin({
			`value fixture.dependencies.collector.collected.one`,
			`value fixture.dependencies.collector.collected.two`
		}).inject(`SubtypeCollectorInjection`);
		assert(subtype.collector.collected.containsEvery({
			fixture.dependencies.collector.collected.one,
			fixture.dependencies.collector.collected.two
		}));
	}
	shared test void whenProvidedCollectableValues_then_shouldInjectSubtypeUnionTypeCollector(){
		value subtype=Depin({
			`value fixture.dependencies.collector.collected.one`,
			`value fixture.dependencies.collector.collected.two`
		}).inject(`SubtypeUnionCollectedInjection`);
		assert(subtype.collector.collected.containsEvery({
			fixture.dependencies.collector.collected.one,
			fixture.dependencies.collector.collected.two
		}));
	}
	shared test void whenProvidedIntegerValues_then_shouldInjectSubtypeIntersectionTypeCollector(){
		value depin=Depin({
			`value fixture.dependencies.collector.one`,
			`value fixture.dependencies.collector.two`,
			`value fixture.dependencies.collector.three`
		});
		value collector=depin.inject(`SubtypeIntersectionCollectedInjection`).collector;
		assert(collector.collected.containsEvery({
			fixture.dependencies.collector.one,
			fixture.dependencies.collector.two,
			fixture.dependencies.collector.three
		}));
	}
}