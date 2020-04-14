import ceylon.collection {
	MutableMap,
	HashMap
}
import ceylon.language.meta.declaration {
	OpenType,
	OpenUnion,
	OpenIntersection
}


import ceylon.logging {
	Logger,
	createLogger=logger
}
import herd.depin.core {

	log,
	Dependency
}
import herd.type.support {

	flat
}
shared class Branch(
	shared TypeIdentifier identifier,
	MutableMap<String,Dependency> map=HashMap<String, Dependency>()
) {
	shared variable Dependency? fallback=null;
	
	shared Dependency? add(Dependency dependency) {
		value replaced = map.put(dependency.name,dependency);
		if(exists replaced){
			log.warn("Replaced dependency when adding ``replaced`` with ``dependency`` for ``identifier``");
		}
		return replaced;
	}
		
	shared  Dependency? get(String name) => map.get(name);
	shared {Dependency*} all=> map.items;
	
	void logReplace(String name, Dependency old, Dependency \inew){
		log.trace("Replacing ``old ``with ``\inew`` for ``name``");
	}
	shared void replace(Dependency replacer(Dependency dependency)){
		value mapItems = map.map((String key -> Dependency item) =>  [key,item,replacer(item)]);
		mapItems.each(([String, Dependency, Dependency] entry) {
			logReplace(*entry);
			map.replaceEntry(*entry);
		});

	}
	value fold=((String partial, String next -> Dependency dependency) => "``partial`` ``next``");
	string=> if(exists dependency = fallback) 
	then map.fold("``identifier``: fallback -> ``dependency.name``,")(fold) 
	else map.fold("``identifier``:")(fold)
	; 
		
	
}
shared class Tree(
	shared MutableMap<TypeIdentifier,Branch> branches= HashMap<TypeIdentifier,Branch>()
) {
	Logger log=createLogger(`module`);
	shared Dependency? get(TypeIdentifier identifier, String name) {
		log.debug("[Getting dependency] ``name`` for type identifier: ``identifier``");
		value branch= branches.get(identifier);
		
		if(exists branch){
			log.trace("Found branch for type identifier ``identifier``, ``branch``");
			value dependency=branch.get(name);
			log.trace("In branch ``identifier`` found dependency ``name``");
			return dependency;
		}
		return null;
	}
	shared Dependency? getFallback(TypeIdentifier identifier){
		log.debug("[Getting fallback dependency] for type identifier: ``identifier``");
		value dependency = branches.get(identifier)?.fallback;
		log.trace("In branch ``identifier`` found fallback dependency ``dependency?.name else "null"``");
		return dependency;
	}
	shared void addFallback(Dependency dependency){
		log.debug("[Adding fallback dependency] ``dependency.name`` for type identifier: ``dependency.identifier``");
		value get = branches.get(dependency.identifier);
		if (exists get) {
			log.trace("Found branch for type identifier ``get.identifier``, ``get``");
			if(exists oldFallback=get.fallback){
				log.warn("[Replacing fallback dependency] ``oldFallback.name`` with ``dependency.name`` for type identifier: ``get.identifier``");
			}
			get.fallback=dependency;
		}
		value branch=Branch(dependency.identifier);
		branches.put(dependency.identifier,branch);
		branch.fallback=dependency;
	}
	shared Dependency? add(Dependency dependency) {
		value get = branches.get(dependency.identifier);
		if (exists get) {
			log.trace("Adding dependency ``dependency.name`` to ``get.identifier`` branch");
			return get.add(dependency);
		}
		log.trace("Adding dependency to new branch ``dependency``");
		value branch=Branch(dependency.identifier);
		branches.put(dependency.identifier,branch);
		return branch.add(dependency);
	}
	
	shared void replace(Dependency selector(Dependency dependency)){
		branches.items.each((Branch branch) {
			log.trace("replacing in branch ``branch``");
			branch.replace(selector); 
		});
	}
	shared {Dependency*} getAllByIdentifier(TypeIdentifier identifier){
		return branches.get(identifier)?.all else empty;
	}
	
	shared {Dependency*} all=> branches.flatMap((TypeIdentifier elementKey -> Branch elementItem) => elementItem.all);
	
	shared {Dependency*} getSubTypeOf(OpenType target) {
		Boolean filter(OpenType -> Branch item);
		switch(target)
		case (is OpenUnion) {
			filter=(OpenType key-> Branch item)=>flat.openTypes(key).containsAny(target.caseTypes);
		}
		case (is OpenIntersection){
			filter=(OpenType key-> Branch item)=>flat.openTypes(key).containsEvery(target.satisfiedTypes);
		}
		else{
			filter=(OpenType key-> Branch item)=>flat.openTypes(key).contains(target);
		}
		return branches
				.filter((OpenType|FunctionalOpenType elementKey -> Branch elementItem) => elementKey is OpenType)
				.map((OpenType|FunctionalOpenType elementKey -> Branch elementItem) {
				assert(is OpenType elementKey );
				return elementKey->elementItem;
		}).filter((OpenType key -> Branch item)=> filter(key->item)
		).flatMap((OpenType key -> Branch item) => item.all);
		
	}
			
	
	
	
	
}
