import herd.depin.core {

	Collector,
	subtype
}
import test.herd.depin.core.integration.injection.collector {

	Collected
}
shared class SubtypeCollectedInjection(shared subtype Collector<Collected> collector){}