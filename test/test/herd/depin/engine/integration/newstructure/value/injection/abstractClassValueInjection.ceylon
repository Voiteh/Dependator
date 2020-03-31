import test.herd.depin.engine.integration.newstructure.\ivalue.dependency {
	AbstractClass
}
shared AbstractClass abstractClassValueInjection(AbstractClass concreteAbstractClassValue) {
	return concreteAbstractClassValue;
}