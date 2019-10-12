import herd.depin.core {

	dependency,
	scanner,
	Depin
}


 dependency String topLevelValue="some value";
 dependency Integer topLevelFunction(String someString) => someString.size;

 Integer topLevelInjection(Integer topLevelFunction(String someString), String topLevelValue){
	return topLevelFunction(topLevelValue);
}

shared void run() {
		value depedencencyDeclarations=scanner.dependencies({`package`});
		value result=Depin(depedencencyDeclarations).inject(`topLevelInjection`);
		assert(topLevelValue.size==result);
}