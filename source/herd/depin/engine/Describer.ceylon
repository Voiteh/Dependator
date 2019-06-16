import ceylon.language.meta {
	type
}
import ceylon.language.meta.declaration {
	AnnotatedDeclaration,
	FunctionDeclaration,
	ValueDeclaration,
	CallableConstructorDeclaration,
	NestableDeclaration,
	Package,
	ValueConstructorDeclaration,
	ClassOrInterfaceDeclaration
}
import ceylon.language.meta.model {
	Type
}



shared class Describer(Type<Annotation>[] control) {
	
shared	Description describe(AnnotatedDeclaration declaration){
		value annotations = declaration.annotations<Annotation>().filter((Annotation element) => control.contains(type(element)));
		Type<> declarationType;
		switch(declaration)
		case (is FunctionDeclaration) {
			
			switch(containerDeclaration=declaration.container)
			case(is Package){
				declarationType=declaration.apply<>().type;
			}
			case (is NestableDeclaration){
				value descriptor = describe(containerDeclaration);
				assert(is Type<Object> descriptorType=descriptor.type);
				declarationType=declaration.memberApply<>(descriptorType).type;
			}
			
		}
		case (is ValueDeclaration) {
			switch(containerDeclaration=declaration.container)
			case(is Package){
				declarationType=declaration.apply<>().type;
			}
			case(is NestableDeclaration){
				value descriptor = describe(containerDeclaration);
				assert(is Type<Object> descriptorType=descriptor.type);
				declarationType=declaration.memberApply<>(descriptorType).type;
				
			}
		}
		case (is CallableConstructorDeclaration) {
			
			if(declaration.toplevel){
				declarationType=declaration.apply<>().type;	
			}else{
				value descriptor = describe(declaration.container);
				assert(is Type<Object> descriptorType=descriptor.type);
				declarationType=declaration.memberApply<>(descriptorType).type;
			}
			
		}
		case (is ClassOrInterfaceDeclaration) {
			if(declaration.toplevel){
				declarationType=declaration.apply<>();
			}else{
				value descriptor = describe(declaration.container);
				assert(is Type<Object> descriptorType=descriptor.type);
				declarationType=declaration.memberApply<>(descriptorType);
			}
		}
		case (is ValueConstructorDeclaration) {
			if(declaration.toplevel){
				declarationType=declaration.apply<>().type;	
			}else{
				value descriptor = describe(declaration.container);
				assert(is Type<Object> descriptorType=descriptor.type);
				declarationType=declaration.memberApply<>(descriptorType).type;
			}
		}
		else{
			throw Exception("Unsupported declaration ``declaration``");
		}
		return Description(declarationType,annotations);
	}
	
	
	
}