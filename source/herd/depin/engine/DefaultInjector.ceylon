import herd.depin.api {
	Registry,
	Injector,
	Dependency
}
shared class DefaultInjector(Registry registry) satisfies Injector{
	shared actual Anything inject(Dependency dependency) => nothing;
	
	
}