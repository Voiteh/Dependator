import herd.depin.core {

	target,
	scanner,
	Depin
}
class TargetedInjection {
	
	String constructorName;
	
	shared new(){
		constructorName="default";
	}
	
	shared target new targetedConstructor(){
		 constructorName="targeted";
	}
	
	
	shared void printInjection(){
		print("Selected construcotr was: ``constructorName``");
	}
	
}


shared void run(){
	Depin{
		scanner.dependencies({`package`});
	}.inject(`TargetedInjection.printInjection`);
}