import ceylon.language.meta.model {
	ClassModel,
	Class,
	MemberClass
}

import herd.depin.api {
	Target
}
shared class TargetFactory() satisfies Target.Factory{
	shared actual Target create(ClassModel<Object> model) {

		switch(model)
		case (is MemberClass<Nothing,Object>) {
			return MemberClassTarget(model);
		}
		else case (is Class<Object>) {
			return ClassTarget(model);
		}else{
			throw Exception("Unssupported model ``model``");
		}
	
	}
	


	
}