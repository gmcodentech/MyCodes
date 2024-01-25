using NewRedisAPI.Models;
namespace NewRedisAPI.Data{
public interface IProductData
{
    bool CreateProduct(Product product);
    IEnumerable<Product?>? GetAllProducts();
    Product GetProduct(string id);
    bool DeleteProduct(string id);
}
}