import ceylon.language.meta.declaration {
	NestableDeclaration,
	ClassDeclaration,
	CallableConstructorDeclaration,
	FunctionalDeclaration,
	FunctionOrValueDeclaration
}

import herd.depin.core {
	Dependency,
	NamedAnnotation
}

shared class DefinitionFactory() {
	
	shared String name(NestableDeclaration declaration) {
		variable String? name;
		try {
			if (exists namedAnnotation = declaration.annotations<NamedAnnotation>().first) {
				name = namedAnnotation.name;
			} else {
				switch (declaration)
				case (is ClassDeclaration) {
					assert (exists value first = declaration.name.first?.lowercased);
					value newName = String({ first,
							*declaration.name.rest });
					name = newName;
				}
				case (is CallableConstructorDeclaration) {
					assert (exists value first = declaration.container.name.first?.lowercased);
					if (declaration.name.empty) {
						value newName = String({ first,
								*declaration.container.name.rest });
						name = newName;
					} else {
						name = declaration.name;
					}
				}
				else {
					name = declaration.name;
				}
			}
		} catch (Throwable x) {
			//Ceylon BUG (https://github.com/eclipse/ceylon/issues/7448)!!!
			//We can't identifiy parameter by annotations but for now we can use name of the parameter.
			//This will be enough for most of cases. 
			name = declaration.name;
		}
		assert (exists shadow = name);
		return shadow;
	}
	
	shared Dependency.Definition create(NestableDeclaration declaration) {
		
		value definitionName = name(declaration);
		
		if (is FunctionalDeclaration declaration) {
			return Dependency.Definition {
				type = declaration.openType;
				name = definitionName;
				nested = declaration.parameterDeclarations.map((FunctionOrValueDeclaration parameter) => create(parameter)).sequence();
			};
		}
		return Dependency.Definition {
			type = declaration.openType;
			name = definitionName;
		};
	}
}
