using System;
namespace SolidExamples;

public interface Database{
	public void Create();
	public void Read();
	public void Update();
	public void Delete();
}

public class SqlDB : Database{
	public void Create(){
		Console.WriteLine("SQL Create");
	}
	public void Read(){
		Console.WriteLine("SQL Read");
	}

	public void Update(){
		Console.WriteLine("SQL Update");
	}

	public void Delete(){
		Console.WriteLine("SQL Delete");
	}
}

public class MongoDB : Database{
	public void Create(){
		Console.WriteLine("MongoDB Create");
	}
	public void Read(){
		Console.WriteLine("MongoDB Read");
	}

	public void Update(){
		Console.WriteLine("MongoDB Update");
	}

	public void Delete(){
		Console.WriteLine("MongoDB Delete");
	}

}

public class Repository{
	private readonly Database _db=null;
	public Repository(Database db){
		_db = db;
	}
	
	public void Save(){
		_db.Create();
	}
	public void Get(){
		_db.Read();
	}
	public void Update(){
		_db.Update();
	}
	public void Delete(){
		_db.Delete();
	}
}


//High level classes should not be dependent on low level classes, 
//instead both high and low level classes should depend on abstraction
public class Program{
	public static void Main(){
		string configDBType = "SolidExamples.MongoDB"; //"SolidExamples.SqlDB";
		Type type = Type.GetType(configDBType);
		Database db = (Database)Activator.CreateInstance(type);
		
		Repository repo = new Repository(db);
		repo.Save();
		repo.Update();
		repo.Delete();
	}
}