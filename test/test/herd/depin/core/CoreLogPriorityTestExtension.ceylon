import ceylon.test {

	TestListener,
	beforeTestRun
}
import ceylon.test.event {

	TestRunStartedEvent
}
import herd.depin.core {

	log
}
import ceylon.logging {

	trace
}
class CoreLogPriorityTestExtension()  satisfies TestListener{

	shared actual void testRunStarted(TestRunStartedEvent event) => log.priority=trace;
}