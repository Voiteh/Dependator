shared abstract class Injection(){
	throws(`class Error`)
	shared formal Anything provide(Provider provider);
	
	shared Result reThrow<Result>(Result() unsafe,String message){
		try{
			return unsafe();
		}catch(Exception x){
			throw Error(message,x);
		}
	}
	
	shared class Error(String message,Throwable? cause= null) extends Exception(message,cause){}
}