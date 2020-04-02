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
	MutableMap<String,Dependency> map=HashMap<String, Dependency>()
) {
	shared variable Dependency? fallback=null;
	
	shared Dependency? add(Dependency dependency) {
		log.trace("Adding dependency to old branch ``dependency``");
		value replaced = map.put(dependency.name,dependency);
		if(exists replaced){
			log.trace("Replaced dependency when adding ``replaced`` with ``dependency``");
		}
		return replaced;
	}
		
	shared  Dependency? get(String identifier) => map.get(identifier);
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
}
shared class Tree(
	shared MutableMap<TypeIdentifier,Branch> branches= HashMap<TypeIdentifier,Branch>()
) {
	Logger log=createLogger(`module`);
	shared Dependency? get(TypeIdentifier identifier, String name) {
		log.trace("Getting dependency for definition: ``identifier`` and name: ``name``");
		value dependency= branches.get(identifier)?.get(name);
		log.trace("In branch found dependency ``dependency else "null"`` for definition: ``identifier``");
		return dependency;
	}
	shared Dependency? getFallback(TypeIdentifier identifier){
		log.trace("Getting fallback dependency for definition: ``identifier``");
		value dependency = branches.get(identifier)?.fallback;
		log.trace("In branch found fallback dependency ``dependency else "null"`` for definition: ``identifier``");
		return dependency;
	}
	shared void addFallback(Dependency dependency){
		value get = branches.get(dependency.identifier);
		if (exists get) {
			get.fallback=dependency;
		}
		value branch=Branch();
		branches.put(dependency.identifier,branch);
		branch.fallback=dependency;
	}
	shared Dependency? add(Dependency dependency) {
		value get = branches.get(dependency.identifier);
		if (exists get) {
			log.trace("Adding dependency to old branch ``dependency``");
			return get.add(dependency);
		}
		log.trace("Adding dependency to new branch ``dependency``");
		value branch=Branch();
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
				.narrow<OpenType->Branch>()
				.filter((OpenType key -> Branch item)=> filter(key->item)
		).flatMap((OpenType key -> Branch item) => item.all);
		
	}
			
	
	
	
	
}
