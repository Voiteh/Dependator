import test.herd.depin.core.integration.dependency {

	Collected
}
import herd.depin.core {

	Collector,
	subtype
}
shared class SubtypeCollectedInjection(shared subtype Collector<Collected> collector){}