import test.herd.depin.core.integration.newstructure.scanner.dependency {

	Outer,
	Scannable
}
shared class Excluded() extends Outer() satisfies Scannable{
	shared actual class Inner()
			 extends super.Inner() {}
	
}