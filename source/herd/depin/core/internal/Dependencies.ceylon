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
shared class Branch(MutableMap<Dependency.Definition,Dependency> map=HashMap<Dependency.Definition, Dependency>()) {
	shared variable Dependency? fallback=null;
	shared Dependency? add(Dependency dependency) {
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
shared class Dependencies(shared MutableMap<OpenType,Branch> branches= HashMap<OpenType,Branch>()) {
	Logger log=createLogger(`module`);
	shared Dependency? get(Dependency.Definition definition) {
		log.trace("Getting dependency for definition: ``definition``");
		value dependency= branches.get(definition.declaration.openType)?.get(definition);
		log.trace("In branch found dependency ``dependency else "null"`` for definition: ``definition``");
		return dependency;
	}
	shared Dependency? getFallback(Dependency.Definition definition){
		log.trace("Getting fallback dependency for definition: ``definition``");
		value dependency = branches.get(definition.declaration.openType)?.fallback;
		log.trace("In branch found fallback dependency ``dependency else "null"`` for definition: ``definition``");
		return dependency;
	}
	shared void addFallback(Dependency dependency){
		value get = branches.get(dependency.definition.declaration.openType);
		if (exists get) {
			get.fallback=dependency;
		}
		value branch=Branch();
		branches.put(dependency.definition.declaration.openType,branch);
		branch.fallback=dependency;
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
	shared {Dependency*} getByType(OpenType type){
		return branches.get(type)?.all else empty;
	}
	
	shared {Dependency*} all=> branches.flatMap((OpenType elementKey -> Branch elementItem) => elementItem.all);
	
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
		return branches.filter(
			(OpenType key -> Branch item)=> filter(key->item)
		).flatMap((OpenType key -> Branch item) => item.all);
		
	}
			
	
	
	
	string => branches.fold("")((String initial, OpenType type -> Branch register) => initial + "``type``: ``register``\n\r" );
	
	
}
