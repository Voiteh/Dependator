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
import ceylon.logging {
	Logger,
	createLogger=logger
}
import herd.depin.engine {

	log
}
shared class Branch(MutableMap<Dependency.Definition,Dependency> map=HashMap<Dependency.Definition, Dependency>()) {
	shared late Dependency fallback;
	shared  Dependency? add(Dependency dependency) {
		log.trace("Adding dependency to old branch ``dependency``");
		value replaced = map.put(dependency.definition,dependency);
		if(exists replaced){
			log.trace("Replaced dependency when adding ``replaced`` with ``dependency``");
		}
		return replaced;
	}
		
	shared  Dependency? get(Dependency.Definition description) => map.get(description);
	shared {Dependency*} all=> map.items;
	
	void logReplace(Dependency.Definition definition, Dependency old, Dependency \inew){
		log.trace("Replacing ``old ``with ``\inew`` for ``definition``");
	}
	shared void replace(Dependency replacer(Dependency dependency)){
		value mapItems = map.map((Dependency.Definition key -> Dependency item) =>  [key,item,replacer(item)]);
		mapItems.each(([Dependency.Definition, Dependency, Dependency] entry) {
			logReplace(*entry);
			map.replaceEntry(*entry);
		});

	}
	string=> map.fold("")((String initial, Dependency.Definition dependency -> Dependency injectable) => initial + ",``dependency.identification``" )	;
}
shared class Dependencies(MutableMap<OpenType,Branch> branches= HashMap<OpenType,Branch>()) {
	Logger log=createLogger(`module`);
	shared Dependency? get(Dependency.Definition definition) {
		log.trace("Getting dependency for definition ``definition``");
		if (exists get = branches.get(definition.declaration.openType)) {
			 value dependency = get.get(definition);
			 log.trace("In old branch found dependency ``dependency else "null"`` for definition ``definition``");
			 return dependency;
		}
		log.trace("No dependency for definition ``definition`` creating branch");
		value branch=Branch();
		branches.put(definition.declaration.openType,branch);
		return null;
	}
	
	shared Dependency? add(Dependency dependency) {
		value get = branches.get(dependency.definition.declaration.openType);
		if (exists get) {
			log.trace("Adding dependency to old branch ``dependency``");
			return get.add(dependency);
		}
		log.trace("Adding dependency to new branch ``dependency``");
		value branch=Branch();
		branches.put(dependency.definition.declaration.openType,branch);
		return branch.add(dependency);
	}
	
	shared void replace(Dependency selector(Dependency dependency)){
		branches.items.each((Branch branch) {
			log.trace("replacing in branch ``branch``");
			branch.replace(selector); 
		});
	}
	
	
	shared {Dependency*} all=> branches.flatMap((OpenType elementKey -> Branch elementItem) => elementItem.all);
	
	string => branches.fold("")((String initial, OpenType type -> Branch register) => initial + "``type``: ``register``\n\r" );
	
}
