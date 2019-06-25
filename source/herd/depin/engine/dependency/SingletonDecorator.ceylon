import herd.depin.api {
	Dependency
}
class SingletonDecorator(Dependency decorated) extends Dependency(decorated.declaration, decorated.definition){
	
	 late Anything data;
	
	shared actual Anything provide(Dependency.Provider provider) {
		try{
			return data;
		}catch(InitializationError x){
			data=decorated.provide(provider);
			return data;
		}
	}
	
	shared actual default String string{
		variable String dataString;
		try{
			dataString="``data else "null"``";
		}catch(InitializationError x){
			dataString="[Not available]";
		}
		return " ``super.string`` = ``dataString``"; 
	}
}