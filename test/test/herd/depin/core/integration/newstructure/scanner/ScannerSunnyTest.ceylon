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
import test.herd.depin.core.integration.newstructure.scanner.dependency {

	Scannable,
	Outer,
	ExtendingClass
}
import test.herd.depin.core.integration.newstructure.scanner.dependency.excluded {

	Excluded
}

testExtension (`class LoggingTestExtension`)
shared class ScannerSunnyTest(){
	
	
	
	shared test void shouldScannInhertiedDependencies(){
		value result=scanner.dependencies({`class ExtendingClass`});
		assert(result.contains(`value ExtendingClass.name`));
		assert(result.contains(`value ExtendingClass.age`));
	}
	shared test void whenScannedInSearchOfInterfaceSatisfingDeclarations_shouldFindSingleClass(){
		value result=scanner.subtypeDependencies(`interface Scannable`,{`module`},{`class Excluded`});
		assert(result.size==1);
	}
	shared test void whenScannedInSearchOfClassExtendigDeclarations_shouldFind2Classes(){
		value result=scanner.subtypeDependencies(`class Outer`,{`module`},{`class Excluded`});
		assert(result.size==2);
	}
}
