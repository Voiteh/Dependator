import herd.depin.core {
	CompleationException
}

import ceylon.language.meta.model {
	Value
}



throws (`class CompleationException`)
shared void compleate(Value<> val, Anything compleationValue) {
	
	if(val.declaration.late ||val.declaration.variable){
		try{
			val.setIfAssignable(compleationValue);
		}catch(InitializationError x){
			throw CompleationException.allreadyCompleated(val);
		}
	}else{
		throw CompleationException.nonLateOrVariable(val);
	}
	
	
}
