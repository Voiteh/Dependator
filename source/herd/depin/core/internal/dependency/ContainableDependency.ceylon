import herd.depin.core {

	Dependency
}
import ceylon.language.meta.declaration {

	NestableDeclaration
}
shared abstract class ContainableDependency(
	String name,
	TypeIdentifier identifier,
	NestableDeclaration declaration,
	shared Dependency? container
) extends Dependency(name,identifier,declaration) {
	
	shared actual default String string=> if (exists dependency = container) then "``dependency``$``super.string``" else super.string;
	
}