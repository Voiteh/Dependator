import ceylon.language.meta.declaration {
	Declaration
}
shared abstract class Scanner() {
	shared formal {Declaration*} scan({Scope*} inclusions,{Scope*} exclusions);
}