import herd.depin.api {
	Handler
}
import ceylon.collection {
	LinkedList,
	MutableMap,
	HashMap
}
import ceylon.language.meta.model {
	Type
}
import ceylon.logging {

	createLogger=logger,
	Logger
}

shared class Handlers(MutableMap<Type<>,LinkedList<Handler<>>> map=HashMap<Type<>,LinkedList<Handler<>>>()) {
	
	Logger log=createLogger(`module`);
	
	shared void add(Type<> eventType,Handler<> handler){
		value list = map.get(eventType);
		if(exists list){
			log.trace("Adding handler ``handler `` to existisng ``list```");
			list.add(handler);
		}else{
			log.trace("Adding handler ``handler `` to new list");
			value newList=LinkedList<Handler<>>();
			newList.add(handler);
			map.put(eventType, newList);
		}
		
	}
	shared {Handler<>*} get(Type<> type){
		if(exists list=map.get(type)){
			log.trace("Getting handlers ``list`` for type``type``");
			return list;
		}
		return empty;
	}
}