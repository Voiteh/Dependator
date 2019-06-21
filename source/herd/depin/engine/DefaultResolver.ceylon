import herd.depin.api {
	Resolver,
	Dependency,
	Registry,
	Identification
}
import ceylon.language.meta.declaration {
	Declaration,
	AnnotatedDeclaration,
	TypedDeclaration
}
import ceylon.language.meta {
	type
}


shared class DefaultResolver(Registry registry) satisfies Resolver{
	shared actual Dependency resolve(Declaration declaration) {
		if(is TypedDeclaration&AnnotatedDeclaration declaration){
		
			value annotations = declaration.annotations<Annotation>()
					.select((Annotation element) => registry.controls.contains(type(element)));
			return Dependency{ 
				type = declaration.openType; 
				identification = if (annotations.empty && registry.controls.contains(`NamedAnnotation`)) 
					then Identification(NamedAnnotation(declaration.name)) 
					else Identification(*annotations);
				
			};
		}
		throw Exception("``declaration`` not supported");
	}
		
	
}