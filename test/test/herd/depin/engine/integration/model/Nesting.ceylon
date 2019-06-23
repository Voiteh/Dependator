shared class Nesting(Integer nesting) {
	
	
	shared class Nested(Integer nested){
		
		shared Integer sum=nesting+nested;
		

		shared actual Boolean equals(Object that) {
			if (is Nested that) {
				return nested==that.nested && 
					sum==that.sum;
			}
			else {
				return false;
			}
		}
		
		shared actual Integer hash {
			variable value hash = 1;
			hash = 31*hash + nested;
			hash = 31*hash + sum;
			return hash;
		}
		
	}
	
}