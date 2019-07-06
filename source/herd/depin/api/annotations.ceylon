import ceylon.language.meta.declaration {
	FunctionOrValueDeclaration,
	ConstructorDeclaration
}

shared final annotation class SingletonAnnotation() satisfies Dependency.Decorator &
	OptionalAnnotation<SingletonAnnotation,FunctionOrValueDeclaration>{

	shared actual Dependency decorate(Dependency dependency) => object extends Dependency.decorated(dependency){
		
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