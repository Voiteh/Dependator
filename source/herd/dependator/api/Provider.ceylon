shared abstract class Provider() {
	shared formal {Targetable|Dependency*} provide({Scope*} scopes);
}