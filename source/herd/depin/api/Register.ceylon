shared interface Register {
	
	shared formal Injectable? add(Dependency description,Injectable injectable);
		
	shared formal Injectable? get(Dependency description);
	
}