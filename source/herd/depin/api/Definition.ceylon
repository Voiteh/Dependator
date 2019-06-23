import ceylon.language.meta.declaration {
	OpenType,
	Declaration
}
shared class Definition{
	
	shared static interface Factory{
		shared formal Definition create(Declaration declaration);
	}

	shared OpenType type;
	shared Identification identification;

	shared new (
		OpenType type,
		Identification identification){
		this.identification = identification;
		this.type = type;
		
	}


	shared actual Boolean equals(Object that) {
		if (is Definition that) {
			return type==that.type && 
				identification==that.identification;
		}
		else {
			return false;
		}
	}
	
	shared actual Integer hash {
		variable value hash = 1;
		hash = 31*hash + type.hash;
		hash = 31*hash + identification.hash;
		return hash;
	}

	
	string =>"``type`` ``identification``";
		
	
}