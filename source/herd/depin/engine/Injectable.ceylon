import ceylon.language.meta.model {
	Type
}
import ceylon.language.meta.declaration {
	Declaration
}
shared interface Injectable {
	shared formal Declaration declaration;
	shared formal {Annotation*} control;
	shared formal Type<Anything> type;
	
	
}