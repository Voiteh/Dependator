import herd.depin.core {

	dependency,
	Depin,
	scanner
}
import ceylon.language.meta.declaration {
	ValueDeclaration
}

class UnaccesibleDependencyContainer(){
	suppressWarnings("unusedDeclaration")
	dependency String name="abc";
}

 

class Activity(){
	late String name;

	shared void onCreate(){
		//Used because can't obtain metamodel reference to local declaration: name value
		assert(exists nameReference = `class Activity`.getDeclaredMemberDeclaration<ValueDeclaration>("name"));
		value dependencies = scanner.dependencies({`package`});
		name = Depin(dependencies).extract<String>(nameReference);
		assert(name=="abc");
		print(name);
	}
}
shared void run(){
	Activity().onCreate();
}