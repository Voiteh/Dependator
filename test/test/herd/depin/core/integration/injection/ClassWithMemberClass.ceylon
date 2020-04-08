shared class ClassWithMemberClass(Integer nesting) {
	
	
	shared class MemberClass(Integer nested){
		
		shared Integer sum=nesting+nested;
		

		shared actual Boolean equals(Object that) {
			if (is MemberClass that) {
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