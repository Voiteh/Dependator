import herd.dependator.api {
	Provider,
	Injector,
	Scope
}
shared class Dependator(
	Injector injector,
	{Provider+} providers,
	{Scope+} scopes
) {
	
	shared void inject(){
		
	
	}
}