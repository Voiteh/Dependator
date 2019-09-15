"Event handler for [[Dependency.Decorator]]s implementing this interface"
shared interface Handler<in Event=Nothing> {
	"[[Depin]] will notify using this event handler method, when any external notification has been passed to [[Depin.notify]] method."
	shared formal void onEvent(Event event);
}