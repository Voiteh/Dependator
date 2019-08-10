import ceylon.language.meta.model {

	Applicable,
	Gettable,
	Qualified
}
shared Object apply(Applicable<Object>|Qualified<Object>|Gettable<Object> model, Anything container=null,Anything[] parameters=[]) {
	
	switch(model)
	case (is Applicable<Object,Nothing>) {
				 return model.apply(*parameters);
	}
	else case (is Gettable<Object,Nothing>) {
		return model.get();
	}
	else case (is Qualified<Object,Nothing>) {
		if(!parameters.empty){
			assert(is Applicable<Object> bind = model.bind(container));
			return apply(bind,container,parameters);
		}
		assert(is Gettable<Object> bind=model.bind(container));
		return apply(bind,container,parameters);
	}
	
}