import herd.depin.engine {
	target,
	named
}
shared class TargetWithTwoCallableConstructors {
	
	shared String something;
	shared new (String something){
		this.something = something;
		
	}
	
	shared target new targetedConstructor(named("Abc") String something){
		this.something=something.reversed;
	}
	
}