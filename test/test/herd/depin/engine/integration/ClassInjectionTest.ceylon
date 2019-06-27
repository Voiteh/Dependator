import ceylon.test {
	test
}

import herd.depin.engine {
	Depin
}

import test.herd.depin.engine.integration.dependency {
	change
}
import test.herd.depin.engine.integration.target {
	Person,
	fixture,
	DataSource,
	DefaultParametersConstructor,
	DefaultedParametersByFunction,
	DefaultedParameterFunction,
	TargetWithTwoCallableConstructors,
	Nesting,
	AnonymousObjectTarget,
	SingletonTarget,
	PrototypeTarget
}
shared class ClassInjectionTest() {
	
	Depin depin=Depin().include{
		 inclusions = {`package test.herd.depin.engine.integration.dependency`};
	};
		
	shared test void shouldInjectJohnPerson(){
			assert(depin.inject(`Person`)==fixture.person.john);
	}
	
	
	
	shared test void shouldInjectMysqlDataSource(){
		assert(depin.inject(`DataSource`)==fixture.dataSouce.mysqlDataSource);
	}
	shared test void shouldInjectNonDefaultParameters(){
		assert(depin.inject(`DefaultParametersConstructor`)==fixture.defaultParameter.instance);
	}
	shared test void shouldInjectDefaultedParameterFromFunction(){
		assert(depin.inject(`DefaultedParametersByFunction`)==fixture.defaultedParameterByFunction.instance);
	}
	shared test void shouldInjectDefaultedParameterClassFunction(){
		assert(depin.inject(`DefaultedParameterFunction`).defaultedFunction()==fixture.defaultedParameterFunction.param);
	}
	shared test void shouldInjectTargetedConstructor(){
		assert(depin.inject(`TargetWithTwoCallableConstructors`).something==fixture.targetWithTwoCallableConstructors.param.reversed);
	}
	
	shared test void shouldInjectNestedClass(){
		assert(depin.inject(`Nesting.Nested`)==fixture.nesting.instance);
	}
	shared test void shouldInjectObjectContainedDependencies(){
		assert(depin.inject(`AnonymousObjectTarget`).innerObjectDependency==fixture.objectDependencies.innerObjectDependency);
	}
	
	shared test void shouldInjectSingleton(){
		change=fixture.changing.initial;
		assert(depin.inject(`SingletonTarget`).singletonDependency==fixture.changing.initial);
		change=fixture.changing.final;
		assert(depin.inject(`SingletonTarget`).singletonDependency==fixture.changing.initial);
	}
	shared test void shouldInjectPrototype(){
		change=fixture.changing.initial;
		assert(depin.inject(`PrototypeTarget`).prototypeDependency==fixture.changing.initial);
		change=fixture.changing.final;
		assert(depin.inject(`PrototypeTarget`).prototypeDependency==fixture.changing.final);
	}
	
}