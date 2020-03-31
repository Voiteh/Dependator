import test.herd.depin.engine.integration.scannable {

	Scanned,
	Scannable
}
shared class Excluded() extends Scanned() satisfies Scannable{
	shared actual class Inner()
			 extends super.Inner() {}
	
}