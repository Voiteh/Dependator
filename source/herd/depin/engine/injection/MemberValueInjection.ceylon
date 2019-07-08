import ceylon.language.meta.model {
	MemberClassValueConstructor
}
import herd.depin.api {
	Dependency,
	Injection
}
shared class MemberValueInjection(MemberClassValueConstructor<> constructor,Dependency container) extends Injection(){
	shared actual Object inject => constructor.bind(container.resolve).get();

}