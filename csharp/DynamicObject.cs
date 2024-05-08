void Main()
{
	dynamic person = new DynamicCustomObject();
	person.FirstName="ABC";
	person.LastName="SR";
	
	Console.WriteLine(person.FirstName + " " + person.LastName);
}

//You can define other methods, fields, classes and namespaces here

class DynamicCustomObject : System.Dynamic.DynamicObject{
	Dictionary<string,object> dictionary = new Dictionary<string,object>();
	
	public int Count{
		get{
			return dictionary.Count;
		}
	}
	
	public override bool TryGetMember(System.Dynamic.GetMemberBinder binder, out object obj){
		string name = binder.Name.ToLower();
		return dictionary.TryGetValue(name,out obj);
	}
	
	public override bool TrySetMember(System.Dynamic.SetMemberBinder binder,object value){
		dictionary[binder.Name.ToLower()]=value.ToString();
		return true;
	}
}
