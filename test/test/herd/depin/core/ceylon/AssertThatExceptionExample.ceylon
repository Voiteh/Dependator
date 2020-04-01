import ceylon.test {

	test,
	ignore
}
class Outer{
	static class Inner() extends Exception(){}
	shared new(){}
	shared void functionWhichThrows(){
		throw Inner();
	}
}

shared ignore test void shouldCompile(){
	
	//assertThatException(()=> Outer().functionWhichThrows()).hasType(`Outer.Inner`);
	
	
}
