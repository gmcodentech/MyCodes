using System.Text.Json;
using NewRedisAPI.Models;
using StackExchange.Redis;
namespace NewRedisAPI.Data{
    public class ProductData : IProductData
    {
        private readonly IConnectionMultiplexer _connection;

        public ProductData(IConnectionMultiplexer connection)
        {
            _connection = connection;
        }
        public bool CreateProduct(Product product)
        {
            product.Id=$"product:{Guid.NewGuid().ToString()}";
            var db = _connection.GetDatabase();
            db.HashSet("productdb",new HashEntry[]{
                new HashEntry(product.Id, JsonSerializer.Serialize(product)),
            });
            return true;
        }

        public bool DeleteProduct(string id)
        {
            var db = _connection.GetDatabase();
            return db.HashDelete("productdb",$"product:{id}");
            
        }

        public Product GetProduct(string id)
        {
            throw new NotImplementedException();
        }

        public IEnumerable<Product?> GetAllProducts()
        {
            var db = _connection.GetDatabase();
            return Array.ConvertAll(db.HashGetAll("productdb"),val=>JsonSerializer.Deserialize<Product>(val.Value.ToString())).ToList();
        }
    }
}