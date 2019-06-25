import ceylon.language.meta.declaration {
	Declaration
}


shared abstract class Dependency extends Injection{
	
	
	shared static interface Factory{
		shared formal Dependency create(Declaration declaration);
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
	
	
	
	
	
	
	
	shared actual default String string => declaration.string;
}

