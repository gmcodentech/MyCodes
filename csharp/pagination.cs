using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.SqlClient;
namespace ProductsDataDemo
{
    public partial class Form1 : Form
    {
        int pageNo = 1;
        int pageSize = 2;
        public Form1()
        {
            InitializeComponent();
        }

        private void btnPrev_Click(object sender, EventArgs e)
        {
            pageNo = pageNo - 1;
            lblPageNo.Text = "Page No." + pageNo.ToString();
            FetchData(pageNo);
        }

        private void btnNext_Click(object sender, EventArgs e)
        {
            pageNo = pageNo + 1;
            lblPageNo.Text = "Page No." + pageNo.ToString();
            FetchData(pageNo);
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            lblPageNo.Text = "Page No." + pageNo.ToString();
            FetchData(pageNo);
        }

        private void FetchData(int pageNo)
        {
            using(SqlConnection cn = new SqlConnection ("Data Source=localhost\\sqlexpress;Database=DemoDb;Integrated Security=true;"))
            {
                SqlCommand cmd = new SqlCommand("GetProducts_SP", cn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@PageNo", pageNo);
                cmd.Parameters.AddWithValue("@PageSize", pageSize);
                cn.Open();
                //thanks for watching this video...
                IDataReader reader = cmd.ExecuteReader();
                var list = new List<Product>();
                while(reader.Read())
                {
                    list.Add(new Product {
                        ID = (int)reader["ID"],
                        Name = reader["Name"].ToString(),
                        Price = (decimal)reader["Price"],
                        Units = (int)reader["Units"],
                    });
                }
                if(list.Count()>0)
                {
                    dgvProducts.DataSource = list;
                }
            }
        }
    }

    public class Product
    {
        public int ID { get; set; }
        public string Name { get; set; }
        public Decimal Price { get; set; }
        public int Units { get; set; }

    }
}
