import ceylon.language.meta.declaration {
	ValueDeclaration
}
import ceylon.language.meta.model {
	ClassModel
}
import ceylon.test {
	testExtension,
	test,
	assertThatException
}

import depin.test.extension {
	LoggingTestExtension
}

import herd.depin.core {
	Depin,
	DependencyAnnotation,
	Injection,
	Dependency
}

import test.herd.depin.core.integration.dependency {
	nested,
	name,
	DataSourceConfiguration,
	InterfaceDependency
}
import test.herd.depin.core.integration.injection {
	DefaultParametersConstructor,
	Nesting,
	DataSource,
	Person,
	SubtypeCollectedInjection
}

testExtension (`class LoggingTestExtension`)
shared class RainyInjectionTest() {
	
	Boolean isInjectionError(ClassModel<Throwable> error) {
		return error == `Injection.Error`;
	}
	Boolean isResolutionError(ClassModel<Throwable> error) {
		return error == `Dependency.ResolutionError`;
	}
	shared test
	void whenProvidedFormalDepenedency_then_shouldThrowException() {
		assertThatException(() => Depin({ `value InterfaceDependency.formalValue` })).hasType(`Exception`);
	}
	
	shared test
	void whenMissingAgeDependancy_then_shouldThrowInjectionError() {
		Depin depin = Depin({ `value name` });
		assertThatException(() => depin.inject(`Person`))
			.hasType(isInjectionError);
	}
	
	shared test
	void whenMissingUrlDependency_shouldThrowInjectionError() {
		{ValueDeclaration*} select = `class DataSourceConfiguration`.memberDeclarations<ValueDeclaration>()
			.select((ValueDeclaration element) => element.annotated<DependencyAnnotation>())
			.filter((ValueDeclaration element) => element != `value DataSourceConfiguration.url`);
		Depin depin = Depin(select);
		assertThatException(() => depin.inject(`DataSource`))
			.hasType(isInjectionError);
	}
	shared test
	void whenMissingNonDefaultParameter_shouldThrowInjectionError() {
		assertThatException(() =>
				Depin().inject(`DefaultParametersConstructor`))
			.hasType(isInjectionError);
	}
	
	shared test
	void whenMissingNestingClass_shouldThrowInjectionError() {
		assertThatException(() =>
				Depin({ `value nested` }).inject(`Nesting.Nested`))
			.hasType(isInjectionError);
	}
	
	shared test
	void whenMissingDependency_shouldThrowDependencyResolutionError_onExtraction() {
		assertThatException(() =>
				Depin({ `value nested` }).extract<String>(`value name`))
			.hasType(isResolutionError);
	}

	shared test
	void whenProvidedSupertypeDependencies_shouldNotInjectThemIntoCollector() {
	assertThatException(() => Depin({
						`value fixture.dependencies.collector.collectable.one`,
						`value fixture.dependencies.collector.collectable.two`
					}).inject(`SubtypeCollectedInjection`)
		)
			.hasType(isInjectionError);
	}
}
