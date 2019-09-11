import ceylon.language.meta.model {

	FunctionModel,
	ClassModel,
	ValueModel
}
import ceylon.language.meta.declaration {

	FunctionOrValueDeclaration,
	ClassDeclaration,
	Module,
	Package
}
shared alias Injectable<Type> => ClassModel<Type>|ValueModel<Type>|FunctionModel<Type>;
shared alias Scope=> ClassDeclaration|FunctionOrValueDeclaration|Package|Module;