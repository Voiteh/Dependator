import herd.depin.core {

	contextual,
	Collector
}


shared String contextualValueInjection(contextual String context){
	return context;
}
shared Integer contextualExtractingInjection(Integer extractingContextualDependency){
	return extractingContextualDependency;
}


shared void contextualCollectorInjection(contextual Collector<Integer> collector){}