using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Microsoft.Reporting.WinForms;
namespace ProductsReportUsingSP
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            PopulateCategories();


        }

        private void PopulateCategories()
        {
            List<Category> categories = new List<Category>();
            string connString = @"Data Source=.\SQLExpress;Database=Northwind;Integrated Security=true;";
            using(SqlConnection cn = new SqlConnection (connString))
            {
                SqlCommand cmd = new SqlCommand("Select CategoryID,CategoryName From Categories", cn);
                cn.Open();
                IDataReader reader = cmd.ExecuteReader();
                
                while (reader.Read())
                {
                    categories.Add(new Category { ID = (int)reader["CategoryID"], Name = reader["CategoryName"].ToString() });
                }
            }

            if(categories.Count()>0)
            {
                categories.Add(new Category {ID=0,Name="All"});

                cmbCategory.DataSource = categories;
                cmbCategory.DisplayMember = "Name";
                cmbCategory.ValueMember = "ID";
            }

        }

        private void btnGenerate_Click(object sender, EventArgs e)
        {
            reportViewer1.ProcessingMode = ProcessingMode.Remote;
            ServerReport serverReport = reportViewer1.ServerReport;

            System.Net.ICredentials credentials = System.Net.CredentialCache.DefaultCredentials;
            ReportServerCredentials reportServerCredentials = serverReport.ReportServerCredentials;
            reportServerCredentials.NetworkCredentials = credentials;

            serverReport.ReportServerUrl = new Uri("http://Sunflower-PC:80/ReportServer");
            serverReport.ReportPath = "/ProductsByCategory";

            ReportParameter categoryParameter = new ReportParameter();
            categoryParameter.Name = "CategoryID";
            categoryParameter.Values.Add(cmbCategory.SelectedValue.ToString());
            categoryParameter.Visible = false;

            ReportParameter priceParameter = new ReportParameter();
            priceParameter.Name = "Price";
            priceParameter.Values.Add(txtPrice.Text);
            priceParameter.Visible = false;
//Thanks for watching this video...
            serverReport.SetParameters(new ReportParameter[] { categoryParameter,priceParameter });

            reportViewer1.RefreshReport();

        }
    }

    public class Category { 
        public int ID { get; set; }
        public string Name { get; set; }
    }
}
