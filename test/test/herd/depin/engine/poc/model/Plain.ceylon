shared class Plain() {
	
	shared enum(one) String name = "I'm plain";
	
	
	shared Integer|ParseException parse(String number){
		return Integer.parse(string);
	}
	shared {Integer*} oneTwoThree()=> {1,2,3};
	
	void smth(String smth){
		print(smth);
	}
	
	
	shared class Inner(){
		shared Integer inner=4;
	}
}