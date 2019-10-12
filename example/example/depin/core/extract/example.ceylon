import herd.depin.core {

	dependency,
	Depin,
	scanner
}

class UnaccesibleDependencyContainer(){
	suppressWarnings("unusedDeclaration")
	dependency String name="abc";
}

late String name;
shared void onCreate(){
	value dependencies = scanner.dependencies({`package`});
	name = Depin(dependencies).extract<String>(`value name`);
	assert(name=="abc");
	print(name);
}
