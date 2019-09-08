shared Result safe<Result>(Result attempt())
(Throwable conversion(Throwable error)){
	try{
		return attempt();
	}catch(Throwable t){
		throw conversion(t);
	}
}