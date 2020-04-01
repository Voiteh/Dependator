import test.herd.depin.core.integration.scannable {

	Scanned
}
class SubpackageInner() extends Scanned(){
	shared actual class Inner()
			 extends super.Inner() {}
	
	
}