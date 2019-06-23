import ceylon.language.meta {
	type
}
import ceylon.language.meta.declaration {
	Declaration,
	AnnotatedDeclaration,
	TypedDeclaration
}

import herd.depin.api {
	Definition,
	Identification,
	NamedAnnotation
}
shared class DefinitionFactory(Identification.Holder holder) satisfies Definition.Factory{
	shared actual Definition create(Declaration declaration) {
		if(is TypedDeclaration&AnnotatedDeclaration declaration){
			variable {Annotation*} annotations;
			try{
				annotations = declaration.annotations<Annotation>()
						.select((Annotation element) => holder.types.contains(type(element)));
			}catch(Exception x){
				//Ceylon BUG!!! We can't identifiy parameter by annotations but for now we can use name of the parameter.
				//This will be enough for most of cases. 
				annotations={NamedAnnotation(declaration.name)};
			}
			return Definition{ 
				type = declaration.openType; 
				identification = if (annotations.empty && holder.types.contains(`NamedAnnotation`)) 
				then Identification(NamedAnnotation(declaration.name)) 
				else Identification(*annotations);
				
			};
		}
		throw Exception("``declaration`` not supported");
	}
	
}