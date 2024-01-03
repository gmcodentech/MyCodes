using System.Data.SqlClient;
using Microsoft.AspNetCore.Mvc;
using ProductsAPI.Models;
using System.Data;
[ApiController]
[Route("[controller]")]
public class ProductsController : ControllerBase{
    private readonly ILogger<ProductsController> _logger;
    public ProductsController(ILogger<ProductsController> logger){
        _logger = logger;
    }

    [HttpGet("product_pages")]
    public int GetProductTotalPages()
    {
        int pageSize = 50;
        int totalPages = 0;
        using(SqlConnection cn = new SqlConnection(GetConnectionString())){
            SqlCommand cmd = new  SqlCommand("GetProductTotalPages_SP",cn);
            cmd.CommandType=CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@PageSize",pageSize);
            cn.Open();
            totalPages = (int)cmd.ExecuteScalar();
        }
        return totalPages;
    }
    private string GetConnectionString(){
        return "Data Source=localhost\\sqlexpress;Database=DemoDB;Integrated Security=true;";
    }
[HttpGet("products/{pageNo}")]
    public IEnumerable<Product> GetProducts(int pageNo){
        int pageSize = 50;
        List<Product> products = new List<Product> ();
        using(SqlConnection cn = new SqlConnection(GetConnectionString())){
            SqlCommand cmd = new SqlCommand ("GetProducts_SP",cn);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@PageNo",pageNo);
            cmd.Parameters.AddWithValue("@PageSize",pageSize);
            cn.Open();
            IDataReader reader = cmd.ExecuteReader();
            while(reader.Read()){
                products.Add(new Product{
                    ID=(int)reader["ID"],
                    Name=reader["Name"].ToString(),
                    Price=(decimal)reader["Price"],
                    Units=(int)reader["Units"]
                });
            }
        }
        return products;
    }

    [HttpPost("save_product")]
    public int SaveProduct(Product product){
        int productId=0;
        using(SqlConnection cn = new SqlConnection(GetConnectionString())){
            SqlCommand cmd = new SqlCommand("SaveProduct_SP",cn);
            cmd.CommandType=CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@Name",product.Name);
            cmd.Parameters.AddWithValue("@Price",product.Price);
            cmd.Parameters.AddWithValue("@Units",product.Units);
            cn.Open();
            productId=(int)cmd.ExecuteScalar();
        }
        return productId;
    }

    [HttpPost("import-csv")]
    public async Task<IActionResult> ImportCSVFile(IFormFile file){
            string path="uploads/tempcsv.csv";
            using(var stream = System.IO.File.Create(path)){
                await file.CopyToAsync(stream);
            }       
            var products = ImportProductData(path);
            foreach(var product in products){
                SaveProduct(product);
            }
            return Ok(new {ImportResult=true});
    }


    private List<Product> ImportProductData(string file){
        return ImportCSVData<Product>(file).ToList();
    }

    private IEnumerable<T> ImportCSVData<T>(string filePath){
        List<T> list = new List<T>();

        List<string> lines = System.IO.File.ReadAllLines(filePath).ToList();
        string headerLine = lines[0];
        var columnNames = headerLine.Split(',');
        var columns = columnNames.Select((v,i)=>new {colIndex=i,colName=v});

        var dataLines = lines.Skip(1);
        Type type = typeof(T);
        foreach(var row in dataLines){
            var rowValues = row.Split(',').ToList();
            var obj = (T?)Activator.CreateInstance(type);
            foreach(var prop in type.GetProperties()){
                var col = columns.Single(c=>c.colName.ToLower()==prop.Name.ToLower());
                var colIndex = col.colIndex;
                var value = rowValues[colIndex];
                prop.SetValue(obj,Convert.ChangeType(value,prop.PropertyType));
//thanks for watching this video...
            }
            if(obj!=null){
            list.Add(obj);
            }
        }

        return list;       
    }
}