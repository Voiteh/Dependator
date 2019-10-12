import herd.depin.core{
	dependency,
	scanner,
	Depin
}


dependency Generic<out Anything> data= Generic("data");


suppressWarnings("uncheckedTypeArguments")
shared Generic<String> injection(Generic<out Anything> data){
	assert( is Generic<String> data  );
	return data;
}

shared void run(){
	value dependencies=scanner.dependencies({`package`});
	value result=Depin(dependencies).inject(`injection`);
	assert(result==data);
	print(result);
}