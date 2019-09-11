import ceylon.language.meta.model {

	Applicable,
	Gettable,
	Qualified
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
		if(!parameters.empty){
			assert(is Applicable<Object> bind = model.bind(container));
			return apply(bind,container,parameters);
		}
		assert(is Gettable<Object> bind=model.bind(container));
		return apply(bind,container,parameters);
	}
	
}