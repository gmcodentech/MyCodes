using System;
using Cassandra;
namespace CassandraCSharpTest;
public class Program{

    public static void Main(){
        var cluster = Cluster.Builder()
            .AddContactPoint("127.0.0.1")
            .WithPort(9042)
            .Build();

        var session = cluster.Connect("testingks");
        var result = session.Execute("Select * From products");

        foreach(var row in result){
            int id = row.GetValue<int>("id");
            string name = row.GetValue<string>("name");
            double price = row.GetValue<double>("price");
            int units = row.GetValue<int>("units");

            Console.WriteLine($"Id:{id}   Name:{name}  Price:{price}  Units:{units}");
        }
    }
}