import herd.depin.core {

	dependency,
	named,
	scanner,
	Depin
}


dependency Integer[] summable =[1,2,3];
class DependencyHolder(named("summable") Integer[] numbers){
	shared named("integerSum") dependency 
	Integer? sum = numbers.reduce((Integer partial, Integer element) => partial+element);
}

void assertInjection(Integer? integerSum){
	assert(exists integerSum,integerSum==6);
}


shared void run(){
	Depin{
		scanner.scan({`package`});
	}.inject(`assertInjection`);
}