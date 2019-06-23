import ceylon.language.meta.model {
	MemberClass,
	ClassModel,
	MemberClassCallableConstructor,
	MemberClassValueConstructor
}

import herd.depin.api {
	Target,
	Dependency
}

class MemberClassTarget(MemberClass<Nothing,Object> member) extends Target(member) {
	shared actual Object inject(Injector injector, Dependency.Provider provider) {
		assert (is ClassModel<Object> containerModel = member.container);
		value container = injector.inject(containerModel);
		switch (constructor = targetConstructor)
		case (is MemberClassCallableConstructor<Nothing>) {
			value parameters = declarationParameters(constructor.declaration.parameterDeclarations,provider);
			value boundConstructor= safe(constructor.bind)([container])
			((Exception cause) => Error.member(constructor.declaration,container,cause));
			return safe(boundConstructor.apply)([*parameters])
			((Exception cause) => Error.memberParameters(boundConstructor.declaration,container,parameters,cause));
		}
		case (is MemberClassValueConstructor<Nothing>) {
			return constructor.bind(container).get();
		}
		else {
			throw Exception("Unsupported constructor ``constructor``");
		}
	}
}
