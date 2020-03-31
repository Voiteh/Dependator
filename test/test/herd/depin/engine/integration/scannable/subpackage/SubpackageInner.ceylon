import test.herd.depin.engine.integration.scannable {

	Scanned
}
class SubpackageInner() extends Scanned(){
	shared actual class Inner()
			 extends super.Inner() {}
	
	
}