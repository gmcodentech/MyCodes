using System;
namespace SolidExamples;

public abstract class Animal{
	public abstract void Walk();
	public abstract void Eat();
}

public class Dog : Animal{
	public override void Walk(){
		Console.WriteLine("walking...");
	}
	public override void Eat(){
		Console.WriteLine("eating...");
	}
}

//objects of sub types should be replace with objects of super type
//dog can be replaced by animal type 
//don't have any method in animal which dog can not behave i.e Fly()

public class Program{
	public static void Main(){
		var animal = new Dog();
		animal.Walk();
		animal.Eat();
	}
}