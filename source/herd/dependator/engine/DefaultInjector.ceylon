import herd.dependator.api {
	Injector,
	Targetable,
	Injectable
}
shared class DefaultInjector() satisfies Injector{
	shared actual Anything inject(Targetable targetable, {Injectable*} injectables) {
		 return targetable.applicable.apply(*injectables.map((Injectable element) => element.injection));
	}
	
}