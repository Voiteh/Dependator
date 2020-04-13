import ceylon.test {

	testExtension,
	test
}
import depin.test.extension {

	LoggingTestExtension
}
import herd.depin.core {

	Depin
}

import test.herd.depin.core.integration.extraction.dependency{
	...
}

testExtension (`class LoggingTestExtension`)
shared class SunnyExtractionTest() {
	
	shared test void whenDependencyProvided_then_shouldExtractIt(){
		value extractedName=Depin({
			`value fixture.val.topLevelString`
		}).extract<String>(`value topLevelString`);
		assert(extractedName==fixture.val.topLevelString);
	}
	
}