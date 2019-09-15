import herd.depin.core {
	dependency,
	Collector,
	scanner,
	Depin
}

dependency Integer one=1;
dependency Integer two=2;

void assertCollectorInjection(Collector<Integer> namingDoesntMatters){
	assert(namingDoesntMatters.collected.containsEvery({one,two}));
}

shared void run(){
	Depin{
		scanner.scan({`package`});
	}.inject(`assertCollectorInjection`);
}