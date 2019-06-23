import ceylon.language.meta.declaration {
	Declaration
}

shared abstract class Injection() of Target|Dependency {
	
	
	shared Result safe<out Result,in Args>(Callable<Result, Args> call)(Args args)(Error handler(Exception exception))   given Args satisfies Anything[]{
		try{
			return call(*args);
		}catch(Exception x){
			throw handler(x);
		}
	}
	
	
	shared class Error extends Exception{
		shared new memberParameters(Declaration declaration,Anything container=null,{Anything*} parameters={},Throwable? cause=null) 
				extends Exception("Can't inject into ``container else "null"`` ``declaration`` with available parameters: ``parameters``",cause){}
		shared new parameters(Declaration declaration,{Anything*} parameters={},Throwable? cause=null) 
				extends Exception("Can't inject ``declaration`` with available parameters: ``parameters``",cause){}
		shared new member(Declaration declaration,Anything container=null,Throwable? cause=null) 
				extends Exception("Can't inject into ``container else "null"`` ``declaration``",cause){}
		shared new (Declaration declaration,Throwable? cause=null) 
				extends Exception("Can't inject ``declaration``",cause){}
		
		
		
	}
}