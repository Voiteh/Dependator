import ceylon.language.meta {
	type
}
"Declaration with this type will be treated as one to contain all dependencies of [[Collected]] type argument. There must be at least one dependency or [[Dependency.ResolutionError]] will be thrown, durring injection"
shared final class Collector<Collected>(
	"Sequence containing collected dependencies"
	shared [Collected+] collected
) given Collected satisfies Object{
	
	string=> ": ``type(this)``: ``collected``";
}