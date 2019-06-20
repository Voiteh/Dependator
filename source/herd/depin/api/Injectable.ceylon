import ceylon.language.meta.model {
	Type
}
import ceylon.language.meta.declaration {
	Declaration
}


shared abstract class Injectable(){
	throws (`class Error`)
	shared formal Anything inject(Provider provider,Resolver resolver);
	
	
	
	shared class Error(Declaration declaration,Type<> type,Dependency description,Throwable? cause=null)
		extends Exception("Can't inject ``declaration`` of type ``type`` described as ``description``",cause){}
}

