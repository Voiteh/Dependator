shared void topLevelInjection(String topLevelFunction()) {
	assert(topLevelFunction()=="Abc");
}


shared void topLevelInjectionForFunctionWithParameter(String? topLevelFunctionWithParameter(String? param)){
	assert(exists result=topLevelFunctionWithParameter("test"),result=="test");
}