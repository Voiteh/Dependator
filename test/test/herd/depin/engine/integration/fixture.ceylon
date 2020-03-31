import test.herd.depin.engine.integration.injection {
	DefaultedParametersByFunction,
	Nesting,
	TargetWithTwoCallableConstructors,
	DefaultParametersConstructor,
	DataSource,
	Person
}
import test.herd.depin.engine.integration.dependency {
	Collected,
	Collectable
}

shared object fixture {
	shared object dependencies {
		shared object methodInjection {
			shared Integer initializer = 5;
			shared Integer parameter = 5;
			shared Integer result = initializer + parameter;
		}
		shared String fallback = "abc";
		shared object collector {
			shared Integer one = 1;
			shared Integer two = 2;
			shared Integer three = 3;
			
			shared object collected {
				shared Collected one = Collected();
				shared Collected two = Collected();
			}
			shared object collectable{
				shared Collectable one = object satisfies Collectable{};
				shared Collectable two = object satisfies Collectable{};
			}
		}
	}
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
	shared object defaultParameter {
		shared String nonDefault = "Abc";
		shared String text = "abc";
		shared DefaultParametersConstructor instance = DefaultParametersConstructor(nonDefault, text);
	}
	shared object defaultedParameterByFunction {
		shared String param = "abc";
		shared DefaultedParametersByFunction instance = DefaultedParametersByFunction(param);
	}
	shared object defaultedParameterFunction {
		shared String param = "abc";
	}
	shared object targetWithTwoCallableConstructors {
		shared String param = "abc";
		shared TargetWithTwoCallableConstructors instance = TargetWithTwoCallableConstructors(param);
	}
	shared object nesting {
		shared Integer nesting = 4;
		shared Integer nested = 5;
		shared Nesting.Nested instance = Nesting(nesting).Nested(nested);
	}
	shared object objectDependencies {
		shared String innerObjectDependency = "abc";
	}
	shared object changing {
		shared Boolean initial = true;
		shared Boolean final = false;
	}
	shared object unshared {
		shared String exposed = "expooooseeed";
	}
	shared object fun {
		shared Integer first = 1;
		shared Integer second = 2;
		shared Integer result = first + second;
	}
}
