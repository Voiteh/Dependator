import ceylon.language.meta.model {
	Type
}
shared class Description(
	shared Type<Anything> type,
	shared {Annotation*} control
){
	
	
	
	shared actual Boolean equals(Object that) {
		if (is Description that,type==that.type) {
			return control.containsEvery(that.control);
		}
		else {
			return false;
		}
	}
	
	shared actual Integer hash {
		variable value hash = 1;
		hash = 31*hash + type.hash;
		hash = 31*hash + control.hash;
		return hash;
	}
	
	
}