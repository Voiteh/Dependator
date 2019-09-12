import herd.depin.core {

	dependency,
	scanner,
	Depin
}



shared dependency String topLevelValue="some value";
shared dependency Integer topLevelFunction(String someString) => someString.size;

shared Integer topLevelInjection(Integer topLevelFunction(String someString), String topLevelValue){
	return topLevelFunction(topLevelValue);
}
//run 
shared void moduleDocs() {
		value depedencencyDeclarations=scanner.scan({`module`});
		value result=Depin(depedencencyDeclarations).inject(`topLevelInjection`);
		assert(topLevelValue.size==result);
}