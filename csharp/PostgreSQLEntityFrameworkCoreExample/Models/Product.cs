using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PGEFExample.Models;

[Table("Products")]
public class Product{
    [Key]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    [Column("id")]
    public int ID{get;set;}

    [Column("name")]
    public string? Name{get;set;}

    [Column("price")]
    public decimal Price{get;set;}

    [Column("units")]
    public int Units{get;set;}
}