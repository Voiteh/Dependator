import ceylon.logging {
	Priority,
	info
}
import ceylon.language.meta.model {
	Type
}


shared class Configuration(
	shared Priority logPriority=info,
	shared Type<Annotation>[] identificationTypes=[`NamedAnnotation`] 
) {}