using System;
namespace SolidExamples;
public abstract class Shape{
	public abstract double CalculateArea();
}

public class Rectangle : Shape{
	public double Height{get;set;}
	public double Width{get;set;}
	public override double CalculateArea(){
		return Height * Width;
	}
}

public class AreaCalculator{
	public double Calculate(Shape shape){
		return shape.CalculateArea();
	}
}

public class Triangle : Shape{
	public double Height{get;set;}
	public double Base{get;set;}
	
	public override double CalculateArea(){
		return 0.5 * Height * Base;
	}
}

public class Program{
	public static void Main(){
		AreaCalculator calculator = new AreaCalculator();
		Rectangle rectangle = new Rectangle(){Height=2.0, Width=3.0};
		Console.WriteLine("Area is " + calculator.Calculate(rectangle));
		
		Console.WriteLine("Area of Triangle is " + calculator.Calculate(new Triangle{Height=2.5,Base=1.2}));
		
	}
}


//public class Shape{
//	public string TypeOfShape{get;set;}
//	public double Height{get;set;}
//	public double Width{get;set;}
//	public double Radius{get;set;}
//	public double CalculateArea(){
//		if(TypeOfShape=="Rectangle"){
//			return Height * Width;
//		}else if(TypeOfShape=="Circle"){
//			return 2.0 * 3.14 * Radius;
//		}else if(TypeOfShape=="Triangle"){
//			return 0.5 * Height * Width;
//		}
//		
//		return 0.0;
//	}
//}
//
//public class Program{
//	public static void Main(){
//		Shape shape = new Shape();
//		shape.Radius = 3.0;
//		shape.TypeOfShape = "Circle";
//		double area = shape.CalculateArea();
//		Console.WriteLine("Area is "+area);
//	}
//}