import herd.depin.core {

	contextual
}


shared String contextualValueInjection(contextual String context){
	return context;
}
shared Integer contextualExtractingInjection(Integer extractingContextualDependency){
	return extractingContextualDependency;
}