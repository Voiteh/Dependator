import ceylon.test {

	testExtension,
	test
}
import depin.test.extension {

	LoggingTestExtension
}
import herd.depin.core {

	scanner
}
import test.herd.depin.engine.integration.dependency {
	ExtendingClass
}

testExtension (`class LoggingTestExtension`)
shared class ScannerSunnyTest(){
	
	
	
	shared test void shouldScannInhertiedDependencies(){
		value result=scanner.dependencies({`class ExtendingClass`});
		assert(result.contains(`value ExtendingClass.name`));
		assert(result.contains(`value ExtendingClass.age`));
	}
	
}