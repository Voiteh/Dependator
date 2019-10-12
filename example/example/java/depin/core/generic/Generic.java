package example.java.depin.core.generic;
public class Generic<T>{
	private T data;
	
	public Generic(T data){
		this.data=data;
	}
	
	public T getData(){
		return data;
	}
	@Override
	public String toString(){
		return data.toString();
	}
}