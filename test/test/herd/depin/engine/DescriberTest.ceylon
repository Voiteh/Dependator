import ceylon.test {
	test
}
import test.herd.depin.engine.model {
	Plain,
	EnumeratedAnnotation,
	one
}
import herd.depin.engine {
	Describer
}
import ceylon.language.meta.model {
	Type,
	UnionType
}
shared class DescriberTest() {
	
	 Describer describer=Describer([`EnumeratedAnnotation`]);
	
	shared test void shouldDescribePlainValue(){
		value val = `value Plain.name`;
		value descriptor = describer.describe(val);
		assert(is Type<String> type=descriptor.type);
		assert(is EnumeratedAnnotation anno=descriptor.control.first);
		assert(anno.enum==one);
	}
	
	shared test void shouldDescribePlainFunction(){
		value declaration = `function Plain.parse`;
		value describe = describer.describe(declaration);
		assert(is UnionType<Integer|ParseException> type=describe.type);
		
	}
	shared test void shouldDescribePlainFunctionWithParametrizedReturnType(){
		value declaration = `function Plain.oneTwoThree`;
		value describe = describer.describe(declaration);
		assert(is Type<Iterable<Integer>> type=describe.type);
		
	}
	shared test void shouldDescribeNestedValue(){
		value declaration = `value Plain.Inner.inner`;
		value describe=describer.describe(declaration);
		assert(is Type<Integer> type=describe.type);
		
	}
	
}