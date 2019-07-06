import ceylon.language.meta.declaration {
	NestableDeclaration,
	FunctionOrValueDeclaration,
	ConstructorDeclaration,
	CallableConstructorDeclaration,
	ValueConstructorDeclaration
}
import ceylon.language.meta.model {
	ClassModel,
	Type
}

import herd.depin.api {
	Injection,
	Dependency
}
import herd.depin.engine {
	TargetSelector
}
import herd.depin.engine.dependency {
	DependencyFactory
}
shared class InjectionFactory(DependencyFactory dependencyFactory,TargetSelector selector) {
	shared Injection create(ClassModel<Object> model) {
	
		ConstructorDeclaration constructorDeclaration = selector.select(model.declaration);

		switch(constructorDeclaration)
		case(is ValueConstructorDeclaration){
			if(is NestableDeclaration containerDeclaration=model.declaration.container){
				assert(is Type<Object> containerType=model.container);
				value constructor=constructorDeclaration.memberApply<Nothing,Object>(containerType);
				value containerDependency=dependencyFactory.create(containerDeclaration, false);
				return MemberValueInjection(constructor, containerDependency);
			}
			value constructor=constructorDeclaration.apply<Object>();
			return ValueConstructorInjection(constructor);
		}
		case(is CallableConstructorDeclaration){
			if(is NestableDeclaration containerDeclaration=model.declaration.container){
				assert(is Type<Object> containerType=model.container);
				value constructor=constructorDeclaration.memberApply<>(containerType, *model.typeArgumentList);
				value containerDependency=dependencyFactory.create(containerDeclaration, false);
				{Dependency*} parameters=constructor.declaration.parameterDeclarations.collect((FunctionOrValueDeclaration element) => dependencyFactory.create(element,true));
				return MemberCallableConstructorInjection(constructor, containerDependency,parameters);
			}
			value constructor=constructorDeclaration.apply<Object>(*model.typeArgumentList);
			{Dependency*} parameters=constructor.declaration.parameterDeclarations.collect((FunctionOrValueDeclaration element) => dependencyFactory.create(element,true));
			return CallableConstructorInjection(constructor, parameters);
			
		}
	
		else{
			throw Exception("unsupported injection for``model``"); 
		}
		
		
	}
	


	
}