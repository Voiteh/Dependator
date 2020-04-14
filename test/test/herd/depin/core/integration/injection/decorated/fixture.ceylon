shared object fixture {
	shared object fallback{
		shared String val = "abc";
	}
	shared object changing {
		shared Boolean initial = true;
		shared Boolean final = false;
	}
}