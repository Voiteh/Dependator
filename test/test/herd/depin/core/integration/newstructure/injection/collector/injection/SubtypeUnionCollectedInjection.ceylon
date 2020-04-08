import herd.depin.core {

	Collector,
	subtype
}
import test.herd.depin.core.integration.newstructure.injection.collector {

	Collectable
}
shared class SubtypeUnionCollectedInjection(shared subtype Collector<Collectable|String> collector){}
