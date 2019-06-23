import ceylon.language.meta.model {
	ClassModel
}

import herd.depin.api {
	Dependency,
	Target
}
shared class TargetInjector(
	Target.Factory targetFactory,
	Dependency.Provider dependencyProvider
) satisfies Target.Injector{
	shared actual Type inject<Type>(ClassModel<Type,Nothing> clazz)
			given Type satisfies Object {
		assert(is Type result=targetFactory.create(clazz).inject(this, dependencyProvider));
		return result;
	}
	
	
	
}