import ceylon.language.meta.model {
	ClassModel,
	FunctionModel,
	ValueModel
}
import ceylon.language.meta.declaration {
	FunctionOrValueDeclaration
}



shared abstract class Target extends Injection {
	
	shared static interface Factory{
		shared formal Target create(ClassModel<Object> model);
	}
	
	shared static interface Injector{
		shared formal Type inject<Type>(ClassModel<Type> clazz) given Type satisfies Object;
	}
	
	ClassModel<Object> model;

	shared new (ClassModel<Object,Nothing> model) extends Injection(){
		this.model=model;
	}
	
	shared {Anything*} declarationParameters(FunctionOrValueDeclaration[] parameters,Dependency.Provider provider) => parameters
			.map((FunctionOrValueDeclaration element) => element->provider.provide(element))
			.filter((FunctionOrValueDeclaration declaration -> Anything val) => !declaration.defaulted||val exists)
			.map((FunctionOrValueDeclaration declaration -> Anything val) => val);
	
	shared FunctionModel<Object>|ValueModel<Object> targetConstructor {
		value chain = model.getCallableConstructors(`TargetAnnotation`)
				.chain(model.getValueConstructors(`TargetAnnotation`));
		if (!model.defaultConstructor exists) {
			if (chain.empty) {
				throw Exception("No constructor annotated by `` `class TargetAnnotation` ``, for multiple, non default constructors there must be one");
			} else if (!chain.rest.empty) {
				throw Exception("Multiple constructor: ``chain.rest``, annotated by `` `class TargetAnnotation` ``, only one can be annotated");
			}
		}
		if (exists targetted = chain.first) {
			return targetted;
		}
		assert (exists default = model.defaultConstructor);
		return default;
	}
	throws(`class Error`)
	shared formal Object inject(Injector injector,Dependency.Provider provider);
	
	
	
	
}