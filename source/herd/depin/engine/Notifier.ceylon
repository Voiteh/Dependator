shared interface Notifier{
	
	shared formal void notify<Event>(Event event);
}