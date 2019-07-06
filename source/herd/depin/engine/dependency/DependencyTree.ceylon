import ceylon.collection {
	MutableMap,
	HashMap
}
import ceylon.language.meta.declaration {
	OpenType
}

import herd.depin.api {
	Dependency
}
shared class Branch(MutableMap<Dependency.Definition,Dependency> map=HashMap<Dependency.Definition, Dependency>()) {
	shared  Dependency? add(Dependency.Definition description, Dependency injectable) {
		return map.put(description,injectable);
	}
		
	shared  Dependency? get(Dependency.Definition description) => map.get(description);
	
	string=> map.fold("")((String initial, Dependency.Definition dependency -> Dependency injectable) => initial + ",``dependency.identification``" )	;
}
shared class DependencyTree(MutableMap<OpenType,Branch> branches= HashMap<OpenType,Branch>()) satisfies Dependency.Tree{
	shared actual Dependency? get(Dependency.Definition definition) {
		if (exists get = branches.get(definition.type)) {
			return get.get(definition);
		}
		value branch=Branch();
		branches.put(definition.type,branch);
		return null;
	}
	shared actual class Mutator()
			 extends super.Mutator() {
		shared actual Dependency? add(Dependency bean) {
			value get = branches.get(bean.definition.type);
			if (exists get) {
				return get.add(bean.definition,bean);
			}
			value branch=Branch();
			branches.put(bean.definition.type,branch);
			return branch.add(bean.definition, bean);
		}
	}
	string => branches.fold("")((String initial, OpenType type -> Branch register) => initial + "``type``: ``register``\n\r" );
	
}
