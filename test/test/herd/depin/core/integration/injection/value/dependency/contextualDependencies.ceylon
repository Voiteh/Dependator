import herd.depin.core {

	contextual,
	factory
}

shared factory Integer extractingContextualDependency(contextual String context){
	return context.size;
}