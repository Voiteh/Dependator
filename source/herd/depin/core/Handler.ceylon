shared interface Handler<in Event=Nothing> {
	shared formal void onEvent(Event event);
}