import ceylon.test {
	test
}

import herd.depin.engine {
	Depin,
	DefaultScanner
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
	PrototypeTarget,
	ExposedTarget
}
import ceylon.language.meta.declaration {
	ValueDeclaration,
	FunctionOrValueDeclaration
}
import herd.depin.api {
	DependencyAnnotation
}
shared class ClassInjectionTest() {
	
	
		
	shared test void shouldInjectJohnPerson(){
			assert(Depin({`value name`,`value age`}).inject(`Person`)==fixture.person.john);
	}
	
	shared test void shouldInjectMysqlDataSource(){
		value select = `class DataSourceConfiguration`.memberDeclarations<ValueDeclaration>()
				.select((ValueDeclaration element) => element.annotated<DependencyAnnotation>());
		assert(Depin(select).inject(`DataSource`)==fixture.dataSouce.mysqlDataSource);
	}
	shared test void shouldInjectNonDefaultParameters(){
		assert(Depin({`value nonDefault`}).inject(`DefaultParametersConstructor`)
			==fixture.defaultParameter.instance);
	}
	shared test void shouldInjectDefaultedParameterFromFunction(){
		assert(Depin({`function defaultedByFunction`}).inject(`DefaultedParametersByFunction`)
			==fixture.defaultedParameterByFunction.instance);
	}
	shared test void shouldInjectDefaultedParameterClassFunction(){
		assert(Depin().inject(`DefaultedParameterFunction`).defaultedFunction()
			==fixture.defaultedParameterFunction.param);
	}
	shared test void shouldInjectTargetedConstructor(){
		assert(Depin({`value something`}).inject(`TargetWithTwoCallableConstructors`).something
			==fixture.targetWithTwoCallableConstructors.param.reversed);
	}
	
	shared test void shouldInjectNestedClass(){
		assert(Depin({`value nesting`,`value nested`}).inject(`Nesting.Nested`)==fixture.nesting.instance);
	}
	shared test void shouldInjectObjectContainedDependencies(){
		value select = `class dependencyHolder`.memberDeclarations<FunctionOrValueDeclaration>()
				.select((FunctionOrValueDeclaration element) => element.annotated<DependencyAnnotation>());
		assert(Depin(select).inject(`AnonymousObjectTarget`).innerObjectDependency
			==fixture.objectDependencies.innerObjectDependency);
	}
	
	shared test void shouldInjectSingleton(){
		change=fixture.changing.initial;
		value depin=Depin({`function singletonDependency`});
		assert(depin.inject(`SingletonTarget`).singletonDependency==fixture.changing.initial);
		change=fixture.changing.final;
		assert(depin.inject(`SingletonTarget`).singletonDependency==fixture.changing.initial);
	}
	shared test void shouldInjectPrototype(){
		change=fixture.changing.initial;
		value depin=Depin({`function prototypeDependency`});
		assert(depin.inject(`PrototypeTarget`).prototypeDependency==fixture.changing.initial);
		change=fixture.changing.final;
		assert(depin.inject(`PrototypeTarget`).prototypeDependency==fixture.changing.final);
	}
	shared test void shouldInjectExposedInterface(){
		value declarations=DefaultScanner().scan({`package test.herd.depin.engine.integration.dependency.unshared`});
		assert(Depin(declarations).inject(`ExposedTarget`).exposing.exposed==fixture.unshared.exposed);
	}
	
}