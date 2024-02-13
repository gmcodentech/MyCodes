using System;
namespace SolidExamples;

public interface SwimmingAnimal{
	public void Swim();
}
public interface WalkingAnimal{
	public void Walk();
}
public interface CrowlingAnimal{
	public void Crowl();
}
public interface FlyingAnimal{
	public void Fly();
}

public class Dog : SwimmingAnimal,WalkingAnimal{
	public void Swim(){
		Console.WriteLine("dog swims...");
	}
	public void Walk(){
		Console.WriteLine("dog walks...");
	}	
}

public class Crow : FlyingAnimal{
	public void Fly(){
		Console.WriteLine("crow flys...");
	}
}

public class Program{
	public static void Main(){
		Dog dog = new Dog();
		dog.Walk();
		
		new Crow().Fly();
	}
}