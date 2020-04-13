import test.herd.depin.core.integration.newstructure.scanner.dependency {

	Outer
}
class SubpackageInner() extends Outer(){
	shared actual class Inner()
			 extends super.Inner() {}
	
	
}