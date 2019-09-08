import ceylon.language.meta {
	type
}
shared class Collector<Collected>(shared [Collected+] collected) given Collected satisfies Object{
	
	string=> ": ``type(this)``: ``collected``";
}