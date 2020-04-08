import herd.depin.core {

	Collector,
	subtype
}
shared class SubtypeIntersectionCollectedInjection(shared subtype Collector<Integral<Integer> &
	Binary<Integer>> collector){}