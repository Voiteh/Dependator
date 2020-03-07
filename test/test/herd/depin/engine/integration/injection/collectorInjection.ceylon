import herd.depin.core {
	Collector,
	subtype
}
import test.herd.depin.engine.integration.dependency {

	Collectable,
	Collected
}
shared class CollectorInjection(shared Collector<Integer> collector) {}


shared class SubtypeCollectorInjection(shared subtype Collector<Collectable> collector){}

shared class CollectedInjection(shared subtype Collector<Collected> collector){}