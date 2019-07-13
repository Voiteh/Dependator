import ceylon.language.meta {
	type
}
import ceylon.language.meta.declaration {
	AnnotatedDeclaration,
	TypedDeclaration,
	Declaration
}

import herd.depin.api {
	Dependency,
	NamedAnnotation,
	Identification
}
import ceylon.logging {

	createLogger=logger,
	Logger
}
import herd.depin.engine {

	log
}
shared class DefinitionFactory(Identification.Holder holder) {
	shared Dependency.Definition create(Declaration declaration) {
	
		if(is TypedDeclaration&AnnotatedDeclaration declaration){
			variable {Annotation*} annotations;
			try{
				annotations = declaration.annotations<Annotation>()
						.select((Annotation element) => holder.types.contains(type(element)));
			}catch(Throwable x){
				//Ceylon BUG (https://github.com/eclipse/ceylon/issues/7448)!!! We can't identifiy parameter by annotations but for now we can use name of the parameter.
				//This will be enough for most of cases. 
				annotations={NamedAnnotation(declaration.name)};
			}
			 value definition = Dependency.Definition{ 
				type = declaration.openType; 
				identification = if (annotations.empty && holder.types.contains(`NamedAnnotation`)) 
				then Identification(NamedAnnotation(declaration.name)) 
				else Identification(*annotations);
				
			};
			log.debug("Created definition ``definition`` for declarationa ``declaration``");
			return definition;
		}
		throw Exception("``declaration`` not supported");
	}
	
}