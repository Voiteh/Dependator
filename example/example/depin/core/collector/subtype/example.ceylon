import herd.depin.core {
	dependency,
	Collector,
	scanner,
	Depin,
	subtype
}

dependency Integer one=1;
dependency Integer two=2;
dependency String str="abc";
dependency Float float=1.3;
void assertSubtypeCollectorInjection(subtype Collector<Object?> namingDoesntMatters){
	assert(namingDoesntMatters.collected.containsEvery({one,two,str,float}));
}

shared void run(){
	Depin{
		scanner.dependencies({`package`});
	}.inject(`assertSubtypeCollectorInjection`);
}

