import ceylon.language.meta.declaration {
	ClassDeclaration,
	Package,
	Module,
	FunctionOrValueDeclaration
}
shared alias Scope=> ClassDeclaration|FunctionOrValueDeclaration|Package|Module;