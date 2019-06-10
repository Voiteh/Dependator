import herd.dependator.api {
	Provider,
	Targetable,
	Dependency,
	Scope
}
shared class AnnotationDrivenProvider() extends Provider(){
	shared actual {Targetable|Dependency*} provide({Scope*} scopes) {
		
	}
	
}