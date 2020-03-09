import ceylon.language.meta.declaration {
	Declaration,
	NestableDeclaration,
	ClassDeclaration,
	CallableConstructorDeclaration
}

import herd.depin.core {
	log,
	Dependency,
	NamedAnnotation,
	Identification
}

shared class DefinitionFactory() {
	
	shared Dependency.Definition create(Declaration declaration) {
		
		if (is NestableDeclaration declaration) {
			variable NamedAnnotation? name;
			try {
				name = declaration.annotations<NamedAnnotation>().first;
			} catch (Throwable x) {
				//Ceylon BUG (https://github.com/eclipse/ceylon/issues/7448)!!!
				//We can't identifiy parameter by annotations but for now we can use name of the parameter.
				//This will be enough for most of cases. 
				name = NamedAnnotation(declaration.name);
			}
			if (!name exists) {
				switch (declaration)
				case (is ClassDeclaration) {
					assert(exists value first = declaration.name.first?.lowercased);
					if (declaration.name.empty) {
						value newName = String({ first,
							*declaration.name.rest });
						name = NamedAnnotation(newName);
					} else {
						name = NamedAnnotation(declaration.name);
					}
				}
				case (is CallableConstructorDeclaration) {
					assert(exists value first = declaration.container.name.first?.lowercased);
					if (declaration.name.empty) {
						value newName = String({ first,
							 *declaration.container.name.rest });
						name = NamedAnnotation(newName);
					} else {
						name = NamedAnnotation(declaration.name);
					}
				}
				else {
					name = NamedAnnotation(declaration.name);
				}
			}
			assert (exists namedAnnotation = name);
			value definition = Dependency.Definition {
				declaration = declaration;
				identification = Identification(namedAnnotation);
			};
			log.debug("[Created Definition]: ``definition``, for declaration: ``declaration``");
			return definition;
		}
		throw Exception("``declaration`` not supported");
	}
}
