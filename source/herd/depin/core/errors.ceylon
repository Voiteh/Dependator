
import ceylon.language.meta.model {

	Value
}


"Thrown when compleation of an object can't be done"
shared class CompleationException extends Exception {
	
	shared Value<> offendingValue;
	shared new nonLateOrVariable(Value<> offendingValue) extends Exception("Counldn't compleate ``offendingValue``, it is not marked as late or variable. ") {
		this.offendingValue=offendingValue;
	}
	shared new allreadyCompleated(Value<> offendingValue) extends Exception("Couldn't compleate  ``offendingValue``, it is allready assigned and it's not a variable to be reasinged") {
		this.offendingValue=offendingValue;
	}
}
