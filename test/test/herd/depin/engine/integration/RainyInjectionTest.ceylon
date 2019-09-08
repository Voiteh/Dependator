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


import herd.depin.engine {
	Depin,
	log,
	DependencyAnnotation,
	Dependency
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
import herd.depin.engine.injection {

	Injection
}
import ceylon.language.meta.model {

	Class,
	ClassModel
}

testExtension (`class LoggingTestExtension`)
shared class RainyInjectionTest() {
	
	log.priority=debug;
	Boolean isInjectionError(ClassModel<Throwable> error){
		return error==`Injection.Error`;
	}
	
	shared test void whenMissingAgeDependancy_then_shourdThrowInjectionError(){
		Depin depin = Depin({`value name`});
		 assertThatException(()=>depin.inject(`Person`))
		 		.hasType(isInjectionError);
	}
	
	shared test void whenMissingUrlDependency_shourdThrowInjectionError(){
		{ValueDeclaration*} select = `class DataSourceConfiguration`.memberDeclarations<ValueDeclaration>()
				.select((ValueDeclaration element) => element.annotated<DependencyAnnotation>())
		.filter((ValueDeclaration element) => element!=`value DataSourceConfiguration.url`);
		Depin depin = Depin(select);
		assertThatException(()=>depin.inject(`DataSource`))
				.hasType(isInjectionError);
	}
	shared test void whenMissingNonDefaultParameter_shourdThrowInjectionError(){
		assertThatException(()=>
			Depin().inject(`DefaultParametersConstructor`))
			.hasType(isInjectionError);
	}

	
	
	shared test void whenMissingNestingClass_shourdThrowInjectionError(){
		assertThatException(()=>
				Depin({`value nested`}).inject(`Nesting.Nested`))
		.hasType(isInjectionError);
	}

	
}