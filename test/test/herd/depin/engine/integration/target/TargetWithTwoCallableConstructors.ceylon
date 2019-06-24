
import herd.depin.api {
	target,
	named
}
shared class TargetWithTwoCallableConstructors {
	
	shared String something;
	shared new (String something){
		this.something = something;
		
	}
	
	shared target new targetedConstructor(named("I will be ignored any way! Bug, bug, bug") String something){
		this.something=something.reversed;
	}
	
}