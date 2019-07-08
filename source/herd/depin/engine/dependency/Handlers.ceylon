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

shared class Handlers(MutableMap<Type<>,LinkedList<Handler<>>> map=HashMap<Type<>,LinkedList<Handler<>>>()) {
	
	shared void add(Type<> eventType,Handler<> handler){
		value list = map.get(eventType);
		if(exists list){
			list.add(handler);
		}else{
			value newList=LinkedList<Handler<>>();
			newList.add(handler);
			map.put(eventType, newList);
		}
		
	}
	shared {Handler<>*} get(Type<> type){
		if(exists list=map.get(type)){
			return list;
		}
		return empty;
	}
}