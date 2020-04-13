shared class ClassWithMemberClassInjection(Integer nesting) {
	
	shared class MemberClass(Integer nested){
		
		shared Integer sum=nesting+nested;
	}
	
}