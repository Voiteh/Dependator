import ceylon.language.meta.model {
	CType=Type
}

"Identifies dependency unequivocaly"
shared class Identification{

	"Holds types of annoations which are used for identifcation"
	shared static class Holder(shared Type[] types){}	
	shared alias Type => CType<Annotation>;

	"Given annotations which identifies [[Dependency]]"
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
	

	string => " ".join(annotations);
}