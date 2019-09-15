import ceylon.language.meta.model {

	Applicable,
	Gettable,
	Qualified,
	Method,
	Attribute,
	MemberClass
}
shared Anything apply(Applicable<>|Qualified<>|Gettable<> model, Anything container=null,Anything[] parameters=[]) {
	
	switch(model)
	case (is Applicable<>) {
				 return model.apply(*parameters);
	}
	else case (is Gettable<>) {
		return model.get();
	}
	else case (is Qualified<>) {
		Applicable<>|Qualified<>|Gettable<> bind;
		switch(model)
		case (is Attribute<> ){
			bind = model.bind(container);
		}
		case (is Method<>){
			bind=model.bind(container);
		}
		case(is MemberClass<>){
			bind =model.bind(container);
		}
		else{
			value bound = model.bind(container);
			if(is Applicable<>|Qualified<>|Gettable<> bound){
				bind=bound;
			}else{
				return bound;
			}
		}
		return apply(bind,container,parameters);
	}
	
}