shared object fixture{
	shared String classParam="abc";
	shared object person {
		shared String name="John";
		shared Integer age=12;
	}
	shared object defaultParameter {
		shared String nonDefault = "Abc";
		shared String text = "abc";
	}
	shared object defaultedParameterFunction {
		shared String param = "abc";
	}
	shared object targetWithTwoCallableConstructors {
		shared String param = "abc";
	}
}