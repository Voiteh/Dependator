import ceylon.language.meta.model {

	FunctionModel,
	ClassModel,
	ValueModel
}
shared alias Injectable<Type> => ClassModel<Type>|ValueModel<Type>|FunctionModel<Type>;