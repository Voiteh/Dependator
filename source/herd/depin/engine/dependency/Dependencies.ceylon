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
	shared {Dependency*} all=> map.items;
	shared void replace(Dependency replacer(Dependency dependency)){
		value mapItems = map.map((Dependency.Definition key -> Dependency item) =>  [key,item,replacer(item)]);
		mapItems.each(([Dependency.Definition, Dependency, Dependency] element) => map.replaceEntry(*element));

	}
	string=> map.fold("")((String initial, Dependency.Definition dependency -> Dependency injectable) => initial + ",``dependency.identification``" )	;
}
shared class Dependencies(MutableMap<OpenType,Branch> branches= HashMap<OpenType,Branch>()) {
	shared Dependency? get(Dependency.Definition definition) {
		if (exists get = branches.get(definition.type)) {
			return get.get(definition);
		}
		value branch=Branch();
		branches.put(definition.type,branch);
		return null;
	}
	
	shared Dependency? add(Dependency bean) {
		value get = branches.get(bean.definition.type);
		if (exists get) {
			return get.add(bean.definition,bean);
		}
		value branch=Branch();
		branches.put(bean.definition.type,branch);
		return branch.add(bean.definition, bean);
	}
	
	shared void replace(Dependency selector(Dependency dependency)){
		branches.items.each((Branch element) => element.replace(selector));
	}
	
	
	shared {Dependency*} all=> branches.flatMap((OpenType elementKey -> Branch elementItem) => elementItem.all);
	
	string => branches.fold("")((String initial, OpenType type -> Branch register) => initial + "``type``: ``register``\n\r" );
	
}
