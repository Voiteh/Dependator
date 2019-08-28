import ceylon.language.meta.declaration {
	FunctionOrValueDeclaration,
	ConstructorDeclaration
}
shared final annotation class FallbackAnnotation() satisfies Dependency.Decorator & OptionalAnnotation<FallbackAnnotation,FunctionOrValueDeclaration>{
	shared actual Dependency.Decorated decorate(Dependency dependency) => object extends Dependency.Decorated(dependency,outer){
		shared actual Anything resolve => dependency;
		

		
			 
	};
}
shared annotation FallbackAnnotation fallback() => FallbackAnnotation();
shared final annotation class EagerAnnotation() satisfies Dependency.Decorator &
		OptionalAnnotation<EagerAnnotation,FunctionOrValueDeclaration>{
	shared actual Dependency.Decorated decorate(Dependency dependency) => object extends Dependency.Decorated(dependency,outer){
		Anything data=dependency.resolve;
		shared actual Anything resolve=> data;
	
	};

}
shared annotation EagerAnnotation eager() => EagerAnnotation();

shared final annotation class SingletonAnnotation() satisfies Dependency.Decorator &
	OptionalAnnotation<SingletonAnnotation,FunctionOrValueDeclaration>{

	shared actual Dependency.Decorated decorate(Dependency dependency) => object extends Dependency.Decorated(dependency,outer){
		
		late Anything data;
		
		shared actual Anything resolve {
			try{
				return data;
			}catch(InitializationError ignored){
				data=dependency.resolve;
				return data;
			}
		}
		
		
	};
	
	
}
shared annotation SingletonAnnotation singleton() => SingletonAnnotation();
shared final annotation class DependencyAnnotation()
		satisfies OptionalAnnotation<DependencyAnnotation,FunctionOrValueDeclaration> {
}

shared annotation DependencyAnnotation dependency() => DependencyAnnotation();

shared final annotation class TargetAnnotation() satisfies OptionalAnnotation<TargetAnnotation,ConstructorDeclaration>{}
shared annotation TargetAnnotation target() => TargetAnnotation();
shared annotation final class NamedAnnotation(String name) satisfies OptionalAnnotation<NamedAnnotation,FunctionOrValueDeclaration>{
	

	shared actual Boolean equals(Object that) {
		if (is NamedAnnotation that) {
			return name==that.name;
		}
		else {
			return false;
		}
	}
	
	shared actual Integer hash => name.hash;
	
	string => name;
}
shared annotation NamedAnnotation named(String name) => NamedAnnotation(name);