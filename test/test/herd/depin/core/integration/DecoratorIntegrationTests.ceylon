import ceylon.test {
	beforeTest,
	test,
	testExtension
}

import depin.test.extension {
	LoggingTestExtension
}

import herd.depin.core {
	Depin
}

import test.herd.depin.core.integration.dependency {
	change,
	singletonDependency,
	prototypeDependency,
	eagerDependency,
	notifiedDependency,
	otherSingletonDependency
}
import test.herd.depin.core.integration.injection {
	PrototypeTarget,
	SingletonTarget,
	EagerTarget,
	NotifiedTarget,
	MultiSingletonTarget
}
testExtension (`class LoggingTestExtension`)
shared class DecoratorIntegrationTests() {
	
	shared beforeTest void reset(){
		change=fixture.changing.initial;
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