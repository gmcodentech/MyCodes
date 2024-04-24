using RestSharp;
namespace RestSharpDemo
{
    public partial class Form1 : Form
    {
        private readonly RestClient _restClient;
        public Form1()
        {
            InitializeComponent();
            string baseUrl = System.Configuration.ConfigurationManager.AppSettings["LocalAPI"] ?? "";
            RestClientOptions options = new RestClientOptions(baseUrl);
            _restClient = new RestClient(options);
        }

        private async void btnLoad_Click(object sender, EventArgs e)
        {
            lblWait.Visible = !lblWait.Visible;
            var products = await Task.Run(() => GetProducts());
            if (products?.Count() > 0)
            {
                dgvProducts.DataSource = products;
            }
            lblWait.Visible = !lblWait.Visible;
        }

        private async Task<List<Product>?> GetProducts()
        {
            RestRequest request = new RestRequest("/Products/products");
            var products = await _restClient.GetAsync<List<Product>>(request);
            return products;
        }

        private async void btnSave_Click(object sender, EventArgs e)
        {
            Product product = new Product { 
                ID=0,
                Name=txtName.Text,
                Price=double.Parse(txtPrice.Text),
                Units=int.Parse(txtUnits.Text)
            };
            int id = await Task.Run(() => SaveProduct(product));
            if(id>0)
            {
                product.ID = id;
                MessageBox.Show($"Product saved with ID: {product.ID}");
            }
        }

        private async Task<int> SaveProduct(Product product)
        {
            RestRequest request = new RestRequest("/Products/save_product");
            request.AddJsonBody<Product>(product);
            var response = await _restClient.PostAsync(request);
            if(response.Content!=null)
            {
                return int.Parse(response.Content);
            }

            return 0;
        }
    }
}