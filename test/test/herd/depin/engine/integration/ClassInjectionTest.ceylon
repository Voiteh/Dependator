import ceylon.test {
	test
}

import herd.depin.engine {
	Depin
}

import test.herd.depin.engine.integration.dependency {
	...
}
import test.herd.depin.engine.integration.target {
	Person,
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
import ceylon.language.meta.declaration {
	ValueDeclaration
}
shared class ClassInjectionTest() {
	
	
		
	shared test void shouldInjectJohnPerson(){
			assert(Depin({`value name`,`value age`}).inject(`Person`)==fixture.person.john);
	}
	
	
	
	shared test void shouldInjectMysqlDataSource(){
		assert(Depin({`class DataSourceConfiguration`,*`class DataSourceConfiguration`.memberDeclarations<ValueDeclaration>() }).inject(`DataSource`)==fixture.dataSouce.mysqlDataSource);
	}
	shared test void shouldInjectNonDefaultParameters(){
		assert(Depin({`value nonDefault`}).inject(`DefaultParametersConstructor`)==fixture.defaultParameter.instance);
	}
	shared test void shouldInjectDefaultedParameterFromFunction(){
		assert(Depin({`function defaultedByFunction`}).inject(`DefaultedParametersByFunction`)==fixture.defaultedParameterByFunction.instance);
	}
	shared test void shouldInjectDefaultedParameterClassFunction(){
		assert(Depin().inject(`DefaultedParameterFunction`).defaultedFunction()==fixture.defaultedParameterFunction.param);
	}
	shared test void shouldInjectTargetedConstructor(){
		assert(Depin({`value something`}).inject(`TargetWithTwoCallableConstructors`).something==fixture.targetWithTwoCallableConstructors.param.reversed);
	}
	
	shared test void shouldInjectNestedClass(){
		assert(Depin({`value nesting`,`value nested`}).inject(`Nesting.Nested`)==fixture.nesting.instance);
	}
	shared test void shouldInjectObjectContainedDependencies(){
		assert(Depin({`class dependencyHolder`}).inject(`AnonymousObjectTarget`).innerObjectDependency==fixture.objectDependencies.innerObjectDependency);
	}
	
	shared test void shouldInjectSingleton(){
		change=fixture.changing.initial;
		assert(Depin({`function singletonDependency`}).inject(`SingletonTarget`).singletonDependency==fixture.changing.initial);
		change=fixture.changing.final;
		assert(Depin({`function singletonDependency`}).inject(`SingletonTarget`).singletonDependency==fixture.changing.initial);
	}
	shared test void shouldInjectPrototype(){
		change=fixture.changing.initial;
		assert(Depin({`function prototypeDependency`}).inject(`PrototypeTarget`).prototypeDependency==fixture.changing.initial);
		change=fixture.changing.final;
		assert(Depin({`function prototypeDependency`}).inject(`PrototypeTarget`).prototypeDependency==fixture.changing.final);
	}
	
}