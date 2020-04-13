import ceylon.test {

	testExtension,
	test,
	beforeTest
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
	
	shared beforeTest void reset(){
		change=fixture.changing.initial;
	}
	
	shared test void whenProvidedFallbackDependency_then_shouldInjectItWhenGivenDependencyMissing(){
		assert(Depin({`value fallbackDependency`})
			.inject(`fallbackInjection`)==fixture.fallback.val);
	}
	
	
	
	shared test void shouldInjectSingleton(){
		value depin=Depin({`value singletonDependency`});
		assert(depin.inject(`SingletonTarget`).singletonDependency==fixture.changing.initial);
		change=fixture.changing.final;
		assert(depin.inject(`SingletonTarget`).singletonDependency==fixture.changing.initial);
	}
	
	shared test void shouldInjectMultipleSingletons(){
		value depin=Depin({`value singletonDependency`,`value otherSingletonDependency`});
		value injected = depin.inject(`MultiSingletonTarget`);
		assert(injected.singletonDependency==fixture.changing.initial);
		assert(injected.otherSingletonDependency==fixture.changing.initial);
		change=fixture.changing.final;
		assert(injected.singletonDependency==fixture.changing.initial);
		assert(injected.otherSingletonDependency==fixture.changing.initial);
	}
	
	shared test void shouldInjectPrototype(){
		value depin=Depin({`value prototypeDependency`});
		assert(depin.inject(`PrototypeTarget`).prototypeDependency==fixture.changing.initial);
		change=fixture.changing.final;
		assert(depin.inject(`PrototypeTarget`).prototypeDependency==fixture.changing.final);
	}
	
	shared test void shouldInjectEager(){
		value depin=Depin({`value eagerDependency`});
		change=fixture.changing.final;
		assert(depin.inject(`EagerTarget`).eagerDependency==fixture.changing.initial);
	}
	shared test void shouldInjectNotified(){
		value depin=Depin({`value notifiedDependency`});
		assert(depin.inject(`NotifiedTarget`).notifiedDependency==fixture.changing.initial);
		depin.notify(fixture.changing.final);
		assert(depin.inject(`NotifiedTarget`).notifiedDependency==fixture.changing.final);
	}
	
}