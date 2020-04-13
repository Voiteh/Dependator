shared object fixture{
	shared object numbers{
		shared Integer one=1;
		shared Integer two=2;
		shared Integer three=3;
		shared Integer sum=one+two+three; 
	}
	shared object collected {
		shared Collected one = Collected();
		shared Collected two = Collected();
	}
	shared object collectable{
		shared Collectable one = object satisfies Collectable{};
		shared Collectable two = object satisfies Collectable{};
	}
	shared object strings{
		shared String one="one";
		shared String two="two";
	}
	shared object ints{
		shared Integer one = 1;
		shared Integer two = 2;
		shared Integer three = 3;
		
	}
}

shared interface Collectable{
	
}

shared  class Collected() satisfies Collectable{
	
}
