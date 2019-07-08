import ceylon.test {
	beforeTest,
	test
}
import test.herd.depin.engine.integration.dependency {
	change,
	singletonDependency,
	prototypeDependency,
	eagerDependency
}
import test.herd.depin.engine.integration.target {
	PrototypeTarget,
	SingletonTarget,
	EagerTarget
}
import herd.depin.engine {
	Depin
}
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
	
}