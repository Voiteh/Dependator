shared class Identification(shared Annotation* annotations){
	

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