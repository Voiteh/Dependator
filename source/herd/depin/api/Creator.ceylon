import ceylon.language.meta.declaration {
	Declaration
}

shared interface Creator{
	shared formal Anything create(Declaration declaration);

}