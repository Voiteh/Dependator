import herd.depin.core {

	dependency,
	named,
	scanner,
	Depin
}


dependency Integer[] summable =[1,2,3];
class DependencyHolder(named("summable") Integer[] numbers){
	named("integerSum") dependency 
	Integer? sum = numbers.reduce((Integer partial, Integer element) => partial+element);
}

void printInjection(Integer? integerSum){
	print("Sum of summable is: ``integerSum else "null"``");
}


shared void run(){
	Depin{
		scanner.scan({`package`});
	}.inject(`printInjection`);
}