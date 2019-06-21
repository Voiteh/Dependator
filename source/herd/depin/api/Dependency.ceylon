import ceylon.language.meta.declaration {
	OpenType
}
shared class Dependency(
	shared OpenType type,
	shared Identification identification
	
){

	shared actual Boolean equals(Object that) {
		if (is Dependency that) {
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