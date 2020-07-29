import herd.depin.core {

	contextual,
	factory,
	Collector
}

shared factory Integer extractingContextualDependency(contextual String context){
	return context.size;
}

shared Integer forCollector=1;

shared Integer contextualCollectorDependency(contextual Collector<Integer> collector){
	return collector.collected.reduce((Integer partial, Integer element) => partial+element);
}