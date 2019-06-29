import ceylon.language.meta.declaration {
	Declaration,
	FunctionOrValueDeclaration
}


shared abstract class Dependency extends Injection{
	
	
	shared static interface Factory{
		throws(`class FactorizationError`)
		shared formal {Dependency+} create(FunctionOrValueDeclaration declaration);
		
		shared class FactorizationError(Declaration declaration,String message,Throwable? cause=null) 
				extends Exception("[``declaration``] ``message``",cause){}
	}
	shared static interface Provider{
		shared formal Anything provide(Declaration declaration);
	}
	shared static interface Registry{
		shared formal Dependency? add(Dependency dependency);
		shared formal Dependency? get(Definition definition);
	}

	
	shared Declaration declaration;
	shared Definition definition;
	shared new (Declaration declaration,Definition definition) extends Injection(){
		this.declaration=declaration;
		this.definition=definition;
	}
	
	
	throws (`class Error`)
	shared formal Anything provide(Provider provider);
	
	shared actual Integer hash {
	variable value hash = 1;
	hash = 31*hash + declaration.hash;
	return hash;
}
	
	
	shared actual Boolean equals(Object that) {
	if (is Dependency that) {
		return declaration==that.declaration ;
	}
	else {
		return false;
	}
}
	
	
	shared actual default String string => declaration.string;
}

