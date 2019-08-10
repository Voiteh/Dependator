import ceylon.language.meta.declaration {
	NestableDeclaration,
	ValueDeclaration,
	FunctionalDeclaration
}

	shared Anything invoke(NestableDeclaration declaration,Anything container=null,Anything[] parameters=[]){
		switch(declaration)
		case (is FunctionalDeclaration) {
			if(exists container){
				return declaration.memberInvoke(container, [],*parameters);
			}else{
				return declaration.invoke([] ,*parameters);
			}
		}
		else case(is ValueDeclaration){
			if(exists container){
				return declaration.memberGet(container);
			}else{
				return declaration.get();
			}
		}
		else{
			throw Exception("Unsupported invocation");
		}
	}
	
