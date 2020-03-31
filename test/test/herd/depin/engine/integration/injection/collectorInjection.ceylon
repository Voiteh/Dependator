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

shared class SubtypeCollectedInjection(shared subtype Collector<Collected> collector){}


shared class SubtypeUnionCollectedInjection(shared subtype Collector<Collectable|String> collector){}

shared class SubtypeIntersectionCollectedInjection(shared subtype Collector<Integral<Integer> &
                  Binary<Integer>> collector){}