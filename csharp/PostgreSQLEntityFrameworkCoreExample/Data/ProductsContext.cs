using Microsoft.EntityFrameworkCore;
using PGEFExample.Models;
namespace PGEFExample.Data;
public class ProductsContext : DbContext{
    
    public DbSet<Product> Products{get;set;}

    public ProductsContext(DbContextOptions<ProductsContext> contextOptions):base(contextOptions){

    }
}