import herd.depin.engine {

	Injectable,
	Dependency
}





shared abstract class Injection{
	
	shared static class Error(Throwable cause,shared Injectable<Anything> injectable, shared Anything container=null,shared {Anything*} parameters=empty)
			extends Exception("Injection failed for ``injectable``, with container:``container  else "null" `` and parameters: ``parameters``",cause){}
			
			Injectable<Anything> injectable;
			Dependency? container;
			{Dependency*} parameters;
			shared new (Injectable<Anything> injectable,Dependency? container,{Dependency*} parameters=empty){
				this.parameters = parameters;
				this.container = container;
				this.injectable = injectable;
				
			} 
			
			
	shared formal Anything inject;
	
	
	shared actual String string {
		if (exists container) {
			return "``container``::``injectable`` ``parameters``";
		}
		return "``injectable`` ``parameters``";
	}
	
}