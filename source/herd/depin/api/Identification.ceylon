import ceylon.language.meta.model {
	CType=Type
}
shared class Identification{

	shared static class Holder(shared Type[] types){}	
	shared alias Type => CType<Annotation>;

	
	shared Annotation[] annotations;
	shared new (Annotation* annotations){
		this.annotations = annotations;
		
	}

	shared actual Boolean equals(Object that) {
		if (is Identification that) {
			return annotations.containsEvery(that.annotations);
		}
		else {
			return false;
		}
	}
	
	shared actual Integer hash => annotations.hash;
	
	string => annotations.string;
}