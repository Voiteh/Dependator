import ceylon.test {
	beforeTest,
	test,
	testExtension
}

import depin.test.extension {
	LoggingTestExtension
}

import herd.depin.engine {
	Depin
}

import test.herd.depin.engine.integration.dependency {
	change,
	singletonDependency,
	prototypeDependency,
	eagerDependency,
	notifiedDependency
}
import test.herd.depin.engine.integration.injection {
	PrototypeTarget,
	SingletonTarget,
	EagerTarget,
	NotifiedTarget
}
testExtension (`class LoggingTestExtension`)
shared class DecoratorIntegrationTests() {
	
	shared beforeTest void reset(){
		change=fixture.changing.initial;
	}
	
	shared test void shouldInjectSingleton(){
		value depin=Depin({`function singletonDependency`});
		assert(depin.inject(`SingletonTarget`).singletonDependency==fixture.changing.initial);
		change=fixture.changing.final;
		assert(depin.inject(`SingletonTarget`).singletonDependency==fixture.changing.initial);
	}
	shared test void shouldInjectPrototype(){
		value depin=Depin({`function prototypeDependency`});
		assert(depin.inject(`PrototypeTarget`).prototypeDependency==fixture.changing.initial);
		change=fixture.changing.final;
		assert(depin.inject(`PrototypeTarget`).prototypeDependency==fixture.changing.final);
	}
	
	shared test void shouldInjectEager(){
		value depin=Depin({`function eagerDependency`});
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