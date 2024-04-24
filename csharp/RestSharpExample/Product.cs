using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RestSharpDemo
{
    internal class Product
    {
        public int ID { get; set; }
        public string? Name { get; set; }
        public double Price { get; set; }

        public int Units { get; set; }
    }
}
