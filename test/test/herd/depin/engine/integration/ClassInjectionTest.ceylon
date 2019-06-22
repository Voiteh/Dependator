import ceylon.test {
	test
}

import herd.depin.engine {
	Depin
}

import test.herd.depin.engine.integration.model {
	Person,
	fixture,
	DataSource,
	DefaultParametersConstructor,
	DefaultedParametersByFunction,
	DefaultedParameterFunction
}
shared class ClassInjectionTest() {
	
	Depin depin=Depin().include{
		 inclusions = {`package test.herd.depin.engine.integration.dependencies`};
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
		assert(depin.inject(`DefaultedParameterFunction`).fun()==fixture.defaultedParameterFunction.param);
	}
}