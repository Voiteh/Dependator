import ceylon.test {
	test
}

import herd.depin.engine {
	Depin
}

import test.herd.depin.engine.integration.model {
	Person,
	fixture,
	DataSource
}
shared class ClassSimpleInjections() {
	
	Depin depin=Depin().include{
		 inclusions = {`package test.herd.depin.engine.integration.dependencies`};
	};
		
	shared test void shouldInjectJohnPerson(){
			assert(depin.inject(`Person`)==fixture.person.john);
	}
	
	shared test void shouldInjectMysqlDataSource(){
		assert(depin.inject(`DataSource`)==fixture.dataSouce.mysqlDataSource);
	}
	
}