shared class MethodInjection(Integer initializerDependency) {
	
	shared Integer method(Integer parameterDependency){
		 return initializerDependency+parameterDependency;
	}
	
}