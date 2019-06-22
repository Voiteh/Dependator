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
			variable {Annotation*} annotations;
			try{
				annotations = declaration.annotations<Annotation>()
					.select((Annotation element) => registry.controls.contains(type(element)));
			}catch(Exception x){
				//Ceylon BUG!!! We can't identifiy parameter by annotations but for now we can use name of the parameter.
				//This will be enough for most of cases. 
				annotations={NamedAnnotation(declaration.name)};
			}
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