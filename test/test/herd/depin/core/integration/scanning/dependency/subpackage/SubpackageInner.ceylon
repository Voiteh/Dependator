import test.herd.depin.core.integration.scanning.dependency {

	Outer
}
class SubpackageInner() extends Outer(){
	shared actual class Inner()
			 extends super.Inner() {}
	
	
}