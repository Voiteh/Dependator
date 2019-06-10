shared interface Injector {
	shared formal Anything inject(Targetable target,{Injectable*} injectables);
}