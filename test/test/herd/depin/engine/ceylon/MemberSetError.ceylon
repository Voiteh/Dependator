import ceylon.test {

	test,
	ignore
}



class TestClass(){
	shared late String attr;
}
ignore
shared test void checkMemberSet(){
	
	
	value test=TestClass();
	value val=`value TestClass.attr`;
	val.memberSet(test, "bleh");
	
}