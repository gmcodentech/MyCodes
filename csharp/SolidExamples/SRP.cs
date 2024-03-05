using System;
namespace SolidExamples;

public class Person{
	public string Name{get;set;}
}
public class Mailer{
	public static void SendMail(Person person){
		Console.WriteLine("sending mail...");
	}
}


//A class should be responsible for single functionality
//OR
//There should be only one reason to change a class

public class Sample{
	public static void Main(){
		Person person = new Person();
		Mailer.SendMail(person);
	}
}


//The following violates the SRP

//public class Person{
//	public string Name{get;set;}
//	 
//	public void SendMail(){
//		Console.WriteLine("send mail...");
//	}
//	 
//	public void CalculateTax(){
//		Console.WriteLine("calculating tax...");
//	}
//	 
//	public void PrintDetails(){
//		Console.WriteLine("printing person details...");
//	}
//}
// 
//public class Sample{
//	public static void Main(){
//		Person person = new Person();
//		person.PrintDetails();
//		person.SendMail();
//		person.CalculateTax();
//	}
//}