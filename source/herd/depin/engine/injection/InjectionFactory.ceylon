import ceylon.language.meta.declaration {
	NestableDeclaration,
	FunctionOrValueDeclaration,
	ConstructorDeclaration,
	CallableConstructorDeclaration,
	ValueConstructorDeclaration
}
import ceylon.language.meta.model {
	ClassModel,
	Type,
	FunctionModel,
	Gettable
}

import herd.depin.api {
	Injection,
	Dependency,
	Injectable
}
import herd.depin.engine {
	TargetSelector,
	log
}
import herd.depin.engine.dependency {
	DependencyFactory
}
shared class InjectionFactory(DependencyFactory dependencyFactory,TargetSelector selector) {
	shared Injection create(Injectable<Anything>model) {
		
		switch(model)
		case (is ClassModel<Anything,Nothing>) {
			ConstructorDeclaration constructorDeclaration = selector.select(model.declaration);
			
			switch(constructorDeclaration)
			case(is ValueConstructorDeclaration){
				if(is NestableDeclaration containerDeclaration=model.declaration.container){
					assert(is Type<Object> containerType=model.container);
					value constructor=constructorDeclaration.memberApply<Nothing,Object>(containerType);
					value containerDependency=dependencyFactory.create(containerDeclaration, false);
					value memberValueInjection = MemberValueInjection(constructor, containerDependency);
					log.debug("[Created Member Value Injection]: ``memberValueInjection`` with container dependency:``containerDependency``");
					return memberValueInjection;
				}
				value constructor=constructorDeclaration.apply<Object>();
				value valueConstructorInjection = GettableInjection(constructor);
				log.debug("[Created  Value Constructor Injection]: ``valueConstructorInjection``");
				return valueConstructorInjection;
			}
			case(is CallableConstructorDeclaration){
				if(is NestableDeclaration containerDeclaration=model.declaration.container){
					assert(is Type<Object> containerType=model.container);
					value constructor=constructorDeclaration.memberApply<>(containerType, *model.typeArgumentList);
					value containerDependency=dependencyFactory.create(containerDeclaration, false);
					{Dependency*} parameters=constructor.declaration.parameterDeclarations.collect((FunctionOrValueDeclaration element) => dependencyFactory.create(element,true));
					value memberCallableConstructorInjection = FunctionModelInjection(constructor, containerDependency,parameters);
					log.debug("[Created Member Callable Constructor Injection]: ``memberCallableConstructorInjection`` with container dependency: ``containerDependency``, using parameters: ``parameters``");
					return memberCallableConstructorInjection;
				}
				value constructor=constructorDeclaration.apply<Object>(*model.typeArgumentList);
				{Dependency*} parameters=constructor.declaration.parameterDeclarations.collect((FunctionOrValueDeclaration element) => dependencyFactory.create(element,true));
				value callableConstructorInjection = FunctionModelInjection(constructor,null, parameters);
				log.debug("[Created Callable Constructor Injection]: ``callableConstructorInjection``, using parameters: ``parameters``");
				return callableConstructorInjection;
			}

			
		}
		else case (is Gettable<Anything,Nothing>) {
			log.debug("[Created Gettable Injection]: ``model``");
			return GettableInjection(model);
		}
		else case (is FunctionModel<Anything,Nothing>) {
			value containerDependency=if (is NestableDeclaration containerDeclaration=model.declaration.container) 
			then dependencyFactory.create(containerDeclaration, false) 
			else null;
			{Dependency*} parameterDependencies=model.declaration.parameterDeclarations.collect((FunctionOrValueDeclaration element) => dependencyFactory.create(element,true));
			log.debug("[Created FunctionModel Injection]: ``model``, for container ``containerDependency else "null"``using parameters: ``parameterDependencies``");
			return FunctionModelInjection(model, containerDependency, parameterDependencies);
		}
					
	}
	


	
}