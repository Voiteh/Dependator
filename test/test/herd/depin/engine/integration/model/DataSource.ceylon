shared class DataSource(
	shared String driverClassName,
	shared String userName,
	shared String password,
	shared String url
) {
	

	shared actual Boolean equals(Object that) {
		if (is DataSource that) {
			return driverClassName==that.driverClassName && 
				userName==that.userName && 
				password==that.password && 
				url==that.url;
		}
		else {
			return false;
		}
	}
	
	shared actual Integer hash {
		variable value hash = 1;
		hash = 31*hash + driverClassName.hash;
		hash = 31*hash + userName.hash;
		hash = 31*hash + password.hash;
		hash = 31*hash + url.hash;
		return hash;
	}
	
}