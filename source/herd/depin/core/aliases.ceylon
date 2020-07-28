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
"Model which can be injected using [[Depin.inject]] method" 
shared alias Injectable<Type=Anything> => ClassModel<Type>|ValueModel<Type>|FunctionModel<Type>;
"Range of decalarations which can be scanned using [[scanner.dependencies]] function"
shared alias Scope=> ClassDeclaration|FunctionOrValueDeclaration|Package|Module;