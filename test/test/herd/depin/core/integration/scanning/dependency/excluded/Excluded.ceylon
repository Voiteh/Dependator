import test.herd.depin.core.integration.scanning.dependency {

	Outer,
	Scannable
}
shared class Excluded() extends Outer() satisfies Scannable{
	shared actual class Inner()
			 extends super.Inner() {}
	
}