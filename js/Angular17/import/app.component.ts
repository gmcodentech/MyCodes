import { Component,inject,OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterOutlet } from '@angular/router';
import { HttpClient, HttpClientModule } from '@angular/common/http';
import * as XLSX from 'xlsx';
import { FormsModule } from '@angular/forms';
@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule, RouterOutlet,HttpClientModule,FormsModule],
  templateUrl: './app.component.html',
  styleUrl: './app.component.css'
})
//thanks for watching this video...
export class AppComponent implements OnInit {
  title = 'Products-APP';
  httpClient = inject(HttpClient);
  products:any = [];
  totalPages:any=[];
  newProduct:boolean=false;
  product:any={id:0,name:'',price:0.0,units:0};
  fetchProducts(pageNo:number):void{
      this.httpClient.get('http://localhost:5058/Products/products/'+pageNo).subscribe((data:any)=>{
        this.products=data;
      });
  }
  fetchProductTotalPages():void{
    this.httpClient.get('http://localhost:5058/Products/product_pages').subscribe((data)=>{
    this.totalPages = Array.from(Array(data),(_,i)=>i+1);
    });
  }

  ngOnInit():void{
    this.fetchProductTotalPages();
    this.fetchProducts(1);
  }
  //export the current page data to an excel file
  exportProducts():void{
    const ws:XLSX.WorkSheet = XLSX.utils.json_to_sheet(this.products);
    const wb:XLSX.WorkBook = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb,ws,'Products');
    const fileName = "Products"+new Date().toLocaleString()+".xlsx";
    XLSX.writeFile(wb,fileName);
  }
  createNewProduct():void{
    this.newProduct = true;
  }
  saveProduct():void{
    this.httpClient.post('http://localhost:5058/Products/save_product',this.product).subscribe(id=>{
      console.log('product saved with new id:'+id);
    });
  }

  fileSelection(event:any):void{
    const formdata = new FormData();
    formdata.append('file',event.target.files[0]);
    this.httpClient.post('http://localhost:5058/Products/import-csv',formdata).subscribe(result=>{
      console.log(result);
    });
  }
}
