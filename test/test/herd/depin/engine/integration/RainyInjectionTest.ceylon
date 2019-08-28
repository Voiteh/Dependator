import ceylon.language.meta.declaration {
	ValueDeclaration
}
import ceylon.logging {
	debug
}
import ceylon.test {
	testExtension,
	test,
	assertThatException
}

import depin.test.extension {
	LoggingTestExtension
}

import herd.depin.api {
	DependencyAnnotation
}
import herd.depin.engine {
	Depin,
	log
}
import herd.validx {
	ValidationError
}

import test.herd.depin.engine.integration.dependency {
	nested,
	name,
	DataSourceConfiguration
}
import test.herd.depin.engine.integration.injection {
	DefaultParametersConstructor,
	Nesting,
	DataSource,
	Person
}

testExtension (`class LoggingTestExtension`)
shared class RainyInjectionTest() {
	
	log.priority=debug;
	
	shared test void whenMissingAgeDependancy_then_shouldThrowValidationException(){
		Depin depin = Depin({`value name`});
		 assertThatException(()=>depin.inject(`Person`))
		 		.hasType(`ValidationError`);
	}
	
	shared test void whenMissingUrlDependency_shouldThrowValidationException(){
		{ValueDeclaration*} select = `class DataSourceConfiguration`.memberDeclarations<ValueDeclaration>()
				.select((ValueDeclaration element) => element.annotated<DependencyAnnotation>())
		.filter((ValueDeclaration element) => element!=`value DataSourceConfiguration.url`);
		Depin depin = Depin(select);
		assertThatException(()=>depin.inject(`DataSource`))
				.hasType(`ValidationError`);
	}
	shared test void whenMissingNonDefaultParameter_shouldThrowValidationException(){
		assertThatException(()=>
			Depin().inject(`DefaultParametersConstructor`))
			.hasType(`ValidationError`);
	}

	
	
	shared test void whenMissingNestingClass_shouldThrowValidationException(){
		assertThatException(()=>
				Depin({`value nested`}).inject(`Nesting.Nested`))
		.hasType(`ValidationError`);
	}

	
}