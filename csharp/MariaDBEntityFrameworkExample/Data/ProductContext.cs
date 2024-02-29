using Microsoft.EntityFrameworkCore;
using EFDemo.Models;
namespace EFDemo.Data;

public class ProductContext : DbContext{
    public DbSet<Product> Products{get;set;}
    private readonly string _connectionString=String.Empty;

    public ProductContext(string connectionString):base(){
        _connectionString = connectionString;
    }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        base.OnConfiguring(optionsBuilder);
        var serverVersion = new MariaDbServerVersion(new Version(11,1,2));
        optionsBuilder.UseMySql(_connectionString,serverVersion);
    }
}