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
	ValueModel
}

import herd.depin.core {
	log,
	Dependency,
	Injectable,
	Injection
}
import herd.depin.core.internal.injection {
	FunctionModelInjection,
	ValueModelInjection
}


shared class InjectionFactory(DependencyFactory dependencyFactory, TargetSelector selector) {
	shared Injection create(Injectable<Anything> injectable) {
		Dependency? container = if (is NestableDeclaration containerDeclaration = injectable.declaration.container)
		then dependencyFactory.create(containerDeclaration)
		else null;
		Injection injection;
		switch (injectable)
		case (is ValueModel<>) {
			injection = ValueModelInjection(injectable, container);
			log.debug("[Created value model injection] ``injection`` for ``injectable`` ");
		}
		case (is ClassModel<Anything,Nothing>) {
			ConstructorDeclaration constructorDeclaration = selector.select(injectable.declaration);
			switch (constructorDeclaration)
			case (is ValueConstructorDeclaration) {
				ValueModel<Object> constructor;
				if (is NestableDeclaration containerDeclaration = injectable.declaration.container) {
					assert (is Type<Object> containerType = injectable.container);
					constructor = constructorDeclaration.memberApply<Nothing,Object>(containerType);
				} else {
					constructor = constructorDeclaration.apply<Object>();
				}
				injection = ValueModelInjection(constructor, container);
				log.debug("[Created value model injection]: ``injection``");
			}
			case (is CallableConstructorDeclaration) {
				FunctionModel<> constructor;
				
				if (is NestableDeclaration containerDeclaration = injectable.declaration.container) {
					assert (is Type<Object> containerType = injectable.container);
					constructor = constructorDeclaration.memberApply<>(containerType, *injectable.typeArgumentList);
				} else {
					constructor = constructorDeclaration.apply<Object>(*injectable.typeArgumentList);
				}
				{Dependency*} parameters = constructor.declaration.parameterDeclarations.collect((FunctionOrValueDeclaration element) => dependencyFactory.create(element));
				injection = FunctionModelInjection(constructor, container, parameters);
				log.debug("[Created constructor model injection]: ``injection`` for ``injection``");
			}
		}
		case (is FunctionModel<Anything,Nothing>) {
			Dependency[] parameters = injectable.declaration.parameterDeclarations.collect((FunctionOrValueDeclaration element) => dependencyFactory.create(element));
			injection = FunctionModelInjection(injectable, container, parameters);
			log.debug("[Created function model injection]: ``injection`` for ``injectable``");
		}
		return injection;
	}
}