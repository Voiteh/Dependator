import ceylon.test {
	test
}
shared class IterablesHashingEqualsTest() {
	
	shared test void whenProvidedTwoSequencec_then_shouldHaveSameHashes(){
		assert(["a","b","c"].hash==["a","b","c"].hash);
	}
	
	shared test void whenProvidedTwoSequencec_then_shouldBeEquals(){
		assert(["a","b","c"]==["a","b","c"]);
	}
}