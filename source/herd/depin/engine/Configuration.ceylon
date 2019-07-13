import ceylon.logging {
	Priority,
	info
}
import ceylon.language.meta.model {
	Type
}
import herd.depin.api {
	NamedAnnotation
}

shared class Configuration(
	shared Priority logPriority=info,
	shared Type<Annotation>[] identificationTypes=[`NamedAnnotation`] 
) {}