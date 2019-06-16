import herd.depin.api {
	Injection,
	Provider
}
import ceylon.language.meta.declaration {
	ValueDeclaration,
	NestableDeclaration,
	Package
}


shared class ValueInjection(ValueDeclaration declaration) extends Injection() {
	shared actual Anything provide(Provider provider) {
		switch(containerDeclaration = declaration.container)
		case (is NestableDeclaration) {
			assert(is Object container = provider.provide(containerDeclaration));
			return reThrow(()=>declaration.memberGet(container),"Couldn't provide value for declaration ``declaration``");
		}
		case (is Package) {
			return reThrow(()=>declaration.get(),"Couldn't provide value for declaration ``declaration``");
		}
	}
	
}