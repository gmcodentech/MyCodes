using System;
using EFDemo.Data;
using EFDemo.Models;

public class Program{
    public static void Main(){
        string cs = "Host=localhost;Database=testdb;User Id=root;Password=1234;";
        using(ProductContext db = new ProductContext (cs)){


            //delete a product
            var product = db.Products.SingleOrDefault(p=>p.ID==8);
            if(product!=null)
            {
                db.Products.Remove(product);
                db.SaveChanges();
                Console.WriteLine("Deleted");
            }
            // //Select a product
            // var product = db.Products.SingleOrDefault(p=>p.Name=="Tea");
            // if(product!=null){
            //     Console.WriteLine(product.Name+" "+product.Price);
            // }

            // //update an existing product
            // var product = db.Products.SingleOrDefault(p=>p.ID==8);
            // if(product!=null){
            // product.Price=100.5;
            // db.SaveChanges();
            // Console.WriteLine("updated");
            // }

            // //add new Product
            // db.Products.Add(new Product{Name="Biscuit",Price=15.8,Units=300});
            // db.SaveChanges();
            // Console.WriteLine("Saved");

            // var products = db.Products;
            // foreach(Product product in products){
            //     Console.WriteLine(product.Name+" "+product.Price+" "+product.Units);
            // }
        }
    }
}