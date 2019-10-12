import herd.depin.core {

	compleatable
}
import test.herd.depin.engine.integration.injection {

	Person
}

shared class AllreadyCompleatedCompleation(Person bleh) {
	shared compleatable late Person john=bleh;
}