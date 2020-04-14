import ceylon.logging {
	logger,
	addLogWriter,
	writeSimpleLog
}
import ceylon.test {
	TestListener
}
import ceylon.test.event {
	TestFinishedEvent
}
variable Boolean lock=false;
void setupWritter(){
	if(!lock){
		lock=true;
		addLogWriter(writeSimpleLog);
	}
}



shared class LoggingTestExtension() satisfies TestListener{
	setupWritter();
	value log =logger(`module`);
		
	shared actual void testFinished(TestFinishedEvent event){
			String state=event.result.state.string.uppercased;
			log.info("----- TEST--``state`` ----- ``event.result.description`` -----");
	}
}