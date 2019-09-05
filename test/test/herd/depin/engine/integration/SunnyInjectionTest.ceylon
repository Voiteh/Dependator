import ceylon.language.meta.declaration {
	ValueDeclaration,
	FunctionOrValueDeclaration,
	NestableDeclaration
}
import ceylon.logging {
	debug
}
import ceylon.test {
	test,
	testExtension
}

import depin.test.extension {
	LoggingTestExtension
}


import herd.depin.engine {
	Depin,
	DefaultScanner,
	log,
	DependencyAnnotation
}

import test.herd.depin.engine.integration.dependency {
	...
}
import test.herd.depin.engine.integration.injection {
	Person,
	DataSource,
	DefaultParametersConstructor,
	DefaultedParametersByFunction,
	DefaultedParameterFunction,
	TargetWithTwoCallableConstructors,
	Nesting,
	AnonymousObjectTarget,
	ExposedTarget,
	functionInjection,
	MethodInjection,
	fallbackInjection,
	CollectorInjection
}

import test.herd.depin.engine.integration {

	fixture
}

testExtension (`class LoggingTestExtension`)
shared class SunnyInjectionTest() {
	
	log.priority=debug;
		
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
	

	
	shared test void shouldInjectExposedInterface(){
		value declarations=DefaultScanner().scan({`package test.herd.depin.engine.integration.dependency.unshared`});
		assert(Depin(declarations).inject(`ExposedTarget`).exposing.exposed==fixture.unshared.exposed);
	}
	
	shared test void shouldInjectIntoFunction(){
		assert(Depin({`value first `,`value second`}).inject(`functionInjection`)==fixture.fun.result);
	}
	shared test void shouldInjectIntoMethod(){
		assert(Depin({`value initializerDependency`,`value parameterDependency`})
			.inject(`MethodInjection.method`)==fixture.dependencies.methodInjection.result);
	}
	
	shared test void shouldInjectFallbackDependency(){
		assert(Depin({`value fallbackDependency`})
			.inject(`fallbackInjection`)==fixture.dependencies.fallback);
	}
	shared test void shouldInjectCollectedDependencies(){
		value depin=Depin({
			`value fixture.dependencies.collector.one`,
			`value fixture.dependencies.collector.two`,
			`value fixture.dependencies.collector.three`
		});
		value collector=depin.inject(`CollectorInjection`).collector;
		assert(collector.collected.containsEvery({
			fixture.dependencies.collector.one,
			fixture.dependencies.collector.two,
			fixture.dependencies.collector.three
		}));
		
	}
}