import herd.depin.core {
	Dependency
}
"This dependency is exposing some nested dependency"
shared interface Exposing {
	shared formal Dependency exposed;
}