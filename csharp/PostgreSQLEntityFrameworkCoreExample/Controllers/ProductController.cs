using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using PGEFExample.Data;
using PGEFExample.Models;

[ApiController]
[Route("api/[controller]")]
public class ProductController : ControllerBase{
    private readonly DbContextOptions<ProductsContext> _context;
    public ProductController(DbContextOptions<ProductsContext> context){
        _context = context;
    }

    [HttpGet("get-products")]
    public IEnumerable<Product> GetProducts(){
        List<Product> products = new  List<Product>();
        using(ProductsContext db = new ProductsContext(_context)){
            products=db.Products.ToList();
        }
        return products;
    }

    [HttpPost("save-product")]
    public bool SaveProduct(Product product){
        bool saved = false;
        using(ProductsContext db = new ProductsContext(_context)){
            db.Products.Add(product);
            db.SaveChanges();
            saved=true;
        }
        return saved;
    }
}