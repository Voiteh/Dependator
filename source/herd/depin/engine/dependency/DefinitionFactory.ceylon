import ceylon.language.meta {
	type
}
import ceylon.language.meta.declaration {
	Declaration,
	NestableDeclaration
}


import herd.depin.engine {
	log,
	Dependency,
	NamedAnnotation
}
shared class DefinitionFactory(Identification.Holder holder) {
	shared Dependency.Definition create(Declaration declaration) {
	
		if(is NestableDeclaration declaration){
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
				declaration = declaration; 
				identification = if (annotations.empty && holder.types.contains(`NamedAnnotation`)) 
				then Identification(NamedAnnotation(declaration.name)) 
				else Identification(*annotations);
				
			};
			log.debug("[Created Definition]: ``definition``, for declaration: ``declaration``");
			return definition;
		}
		throw Exception("``declaration`` not supported");
	}
	
}