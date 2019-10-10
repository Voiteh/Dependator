import ceylon.language.meta.declaration {
	ClassDeclaration
}
import ceylon.language.meta.model {
	Class
}
import ceylon.test {
	test
}

shared class Dependency(String bleh,String obleh){
	
	shared {Integer*} count={bleh.size,obleh.size};
	
}

shared class Target(shared {Integer*} count){}
shared test void wholeSimplfiedFlow(){
	value targetClass = `Target`;
	
	
	assert(exists constructor=targetClass.defaultConstructor);
	assert(exists paramType=constructor.parameterTypes.first);
	assert(exists paramDecl=constructor.declaration.parameterDeclarations.first);
	//found by OpenType and Identifiaction
	value countDeclaration = `value Dependency.count`;
	value openType = countDeclaration.openType;
	print(openType);
	assert(is ClassDeclaration container=countDeclaration.container);
	assert(is Class<Object> clazz=container.apply<>());
	//"Arguments bleh and obleh found the same way the countDeclaration"
	Object instance=clazz.apply("bleh","obleh");
	value count = countDeclaration.memberGet(instance);
	value target=constructor.apply(count);
	assert(target.count.containsEvery({4,5}));
	

	
}
{String*} abc={"a","b","c"};
{Integer*} oneTwoThree={1,2,3};
{String*} def={"d","e","f"};

Generic generic<Generic>(Generic generic){ return generic; }

Other other<Other>(Other other){return other;}

shared test void shouldBeDifferentOpenType(){
	assert(`value abc`.openType!=`value oneTwoThree`.openType);
	assert(`function generic`.openType!=`function other`.openType);
}

shared test void shouldBeSameOpenType(){
	assert(`value abc`.openType==`value def`.openType);

}


shared class Alala<Smth>(shared Smth smth){}


shared test void getSmthOpenType(){
	print(`Alala<String>.smth`.declaration.openType);
	
	
}