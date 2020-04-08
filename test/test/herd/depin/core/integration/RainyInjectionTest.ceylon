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
	...
}
import test.herd.depin.core.integration.injection {
	...
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
				Depin().inject(`ClassWithDefaultedInitializerParameter`))
			.hasType(isInjectionError);
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
