
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
		shared DefaultParametersModel instance=DefaultParametersModel(nonDefault,text) ;
	}
}