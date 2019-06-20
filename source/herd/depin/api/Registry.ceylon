import ceylon.language.meta.model {
	Type
}

shared interface Registry{
	shared formal Injectable? add(Dependency dependency,Injectable injectable);
	shared formal Injectable? get(Dependency dependency);
	shared formal Type<Annotation>[] controls;
	
}