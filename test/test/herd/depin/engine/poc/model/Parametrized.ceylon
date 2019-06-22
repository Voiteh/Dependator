shared class Parametrized<Param>(shared Param param){
	

	shared actual Boolean equals(Object that) {
		if (is Parametrized<Param> that) {
			if(exists param, exists it = that.param){
				return param==it;
			}
			else if(! exists param, !exists it=that.param){
				return true;
			}
		}
		return false;
	}
	
	shared actual Integer hash => if (exists param) then param.hash else super.hash;
	
}