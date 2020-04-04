import ceylon.language.meta.declaration {
	FunctionOrValueDeclaration,
	ConstructorDeclaration,
	ClassDeclaration,
	ValueDeclaration,
	FunctionDeclaration
}
import ceylon.language.meta.model {
	ValueModel
}


see(`function fallback`)
shared final annotation class FallbackDecorator() satisfies Dependency.Decorator & OptionalAnnotation<FallbackDecorator,FunctionOrValueDeclaration>{
	shared actual Dependency.Decoration decorate(Dependency dependency) => object extends Dependency.Decoration(dependency,outer){
		shared actual Anything resolve => dependency.resolve;
	};
	string => "fallback";
}
"Decorator annotation, used for creating a [[Dependency]], which will be taken in consideration,
  whenever any other [[Dependency]] of declared type, can't be found, for injection"
shared annotation FallbackDecorator fallback() => FallbackDecorator();



see(`function eager`)
shared final annotation class EagerDecorator() satisfies Dependency.Decorator &
		OptionalAnnotation<EagerDecorator,ValueDeclaration>{
	shared actual Dependency.Decoration decorate(Dependency dependency) => object extends Dependency.Decoration(dependency,outer){
		Anything data=dependency.resolve;
		shared actual Anything resolve=> data;
	
	};
	string => "eager";
}
"Decoration annotation, used for creating [[Dependency]], which will be resolved eagerly durring [[Depin]] object creation, rather than durring injection process. Use it togather with [[SingletonDecorator]]"
shared annotation EagerDecorator eager() => EagerDecorator();

see(`function singleton`)
shared final annotation class SingletonDecorator() satisfies Dependency.Decorator &
	OptionalAnnotation<SingletonDecorator,ValueDeclaration>{

	shared actual Dependency.Decoration decorate(Dependency dependency) => object extends Dependency.Decoration(dependency,outer){
		
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
	
	string => "singleton";
}

"Decorator annotation, used to cache resolution of dependency decorated with. "
shared annotation SingletonDecorator singleton() => SingletonDecorator();


see(`function dependency`)
shared final annotation class DependencyAnnotation()
		satisfies OptionalAnnotation<DependencyAnnotation,FunctionOrValueDeclaration> {
	string => "dependency";
}

"Annotation used for creation of scannable declaration for [[scanner.dependencies]] function. Only declaration annotated with this annotation are taken in consideration when scanned. "
shared annotation DependencyAnnotation dependency() => DependencyAnnotation();

see(`function target`)
shared final annotation class TargetAnnotation() satisfies OptionalAnnotation<TargetAnnotation,ConstructorDeclaration>{
	string => "target";
}

"Annotation, which allows selecting of constructor used for injection using [[Depin.inject]]. "
shared annotation TargetAnnotation target() => TargetAnnotation();

see(`function named`)
shared annotation final class NamedAnnotation(

	shared String name
) satisfies OptionalAnnotation<NamedAnnotation,FunctionOrValueDeclaration|ClassDeclaration>{
	
	string => name;
}
"Annotation allowing to rename dependency, which will be used for injection"
shared annotation NamedAnnotation named(
	"New name of dependency"
	String name
) => NamedAnnotation(name);

see(`function subtype`)
shared annotation final class SubtypeAnnotation() satisfies OptionalAnnotation
		<SubtypeAnnotation,ValueDeclaration,ValueModel<Collector<Anything>>>
{
	string => "subtype";
}
"Annotation used for defining wheter collected dependencies should be subtype of given type parameter of [[Collector]]"
shared annotation SubtypeAnnotation subtype()=> SubtypeAnnotation();


see(`function factory`)
shared annotation final class FactoryAnnotation() satisfies OptionalAnnotation<FactoryAnnotation, FunctionDeclaration>{
	string => "factory";
}

"Annotation to mark functions as factory methods. They are not injectable as function but only as a result of factorization (value)"
shared annotation FactoryAnnotation factory() => FactoryAnnotation();


