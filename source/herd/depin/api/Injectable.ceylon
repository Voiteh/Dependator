import ceylon.language.meta.declaration {
	Declaration
}


shared abstract class Injectable(Declaration declaration){
	throws (`class Error`)
	shared formal Anything inject(Creator injector);
	
	
	
	shared class Error extends Exception{
		shared new member(Throwable? cause=null,Anything container=null,{Anything*} parameters={}) 
				extends Exception("Can't inject into ``container else "null"`` ``declaration`` with available parameters: ``parameters``",cause){}
		shared new (Throwable? cause=null,{Anything*} parameters={}) 
				extends Exception("Can't inject ``declaration`` with available parameters: ``parameters``",cause){}
		
		
		
	}
	
	
	
	string => declaration.string;
}

