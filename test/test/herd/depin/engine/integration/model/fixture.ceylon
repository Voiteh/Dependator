
shared object fixture {
	shared object person {
		shared Person john = Person("John", 123);
	}
	shared object dataSouce {
		shared DataSource mysqlDataSource = DataSource {
			driverClassName = "com.mysql.cj.jdbc.Driver";
			userName = "mysqluser";
			password = "mysqlpass";
			url = "jdbc:mysql://localhost:3306/myDb?createDatabaseIfNotExist=true";
		};
	}
	shared object defaultParameter{
		shared String nonDefault="Abc";
		shared String text="abc";
		shared DefaultParametersConstructor instance=DefaultParametersConstructor(nonDefault,text) ;
	}
	shared object defaultedParameterByFunction{
		shared String param="abc";
		shared DefaultedParametersByFunction instance= DefaultedParametersByFunction(param);
	}
	shared object  defaultedParameterFunction {
		shared String param = "abc";
	}
	shared object targetWithTwoCallableConstructors{
		shared String param ="abc";
		shared TargetWithTwoCallableConstructors instance= TargetWithTwoCallableConstructors(param);
	}
	shared object nesting{
		shared Integer nesting =4;
		shared Integer nested=5;
		shared Nesting.Nested instance=Nesting(nesting).Nested(nested) ;
	}
}