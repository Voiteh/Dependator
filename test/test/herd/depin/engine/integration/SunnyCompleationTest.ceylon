import ceylon.test {
	testExtension,
	test
}
import depin.test.extension {
	LoggingTestExtension
}
import test.herd.depin.engine.integration.compleation {
	PositiveCompleation
}
import herd.depin.core {
	Depin
}

testExtension (`class LoggingTestExtension`)
shared class SunnyCompleationTest() {
	
	shared test
	void shouldCompleateJohnDependency() {
		
		value target = PositiveCompleation();
		Depin({ `value fixture.person.john` }).compleate(target);
		assert (target.john == fixture.person.john);
	}
}
