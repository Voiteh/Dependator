shared class Person(shared String name,shared Integer age) {
		

	shared actual Boolean equals(Object that) {
		if (is Person that) {
			return name==that.name && 
				age==that.age;
		}
		else {
			return false;
		}
	}
	
	shared actual Integer hash {
		variable value hash = 1;
		hash = 31*hash + name.hash;
		hash = 31*hash + age;
		return hash;
	}
	
}