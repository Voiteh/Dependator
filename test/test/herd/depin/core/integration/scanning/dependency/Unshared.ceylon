class Unshared() extends Outer(){
	shared actual class Inner()
			 extends super.Inner() {}
	
}