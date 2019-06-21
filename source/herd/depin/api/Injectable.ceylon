import ceylon.language.meta.model {
	Type
}
import ceylon.language.meta.declaration {
	Declaration
}


shared abstract class Injectable(Declaration declaration){
	throws (`class Error`)
	shared formal Anything inject(Creator injector);
	
	
	
	shared class Error(Declaration declaration,Type<> type,Dependency description,Throwable? cause=null)
		extends Exception("Can't inject ``declaration`` of type ``type`` described as ``description``",cause){}
	
	string => declaration.string;
}

