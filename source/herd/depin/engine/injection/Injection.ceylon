import herd.depin.engine {

	Injectable
}





shared interface Injection {
	
	shared static class Error(Throwable cause,shared Injectable<Anything> injectable, shared Anything container=null,shared {Anything*} parameters=empty)
			extends Exception("Injection failed for ``injectable``, with container:``container  else "null" `` and parameters: ``parameters``",cause){}
			
	
	shared formal Anything inject;
	
	
	
	
}