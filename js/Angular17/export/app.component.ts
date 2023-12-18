import { Component,inject,OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterOutlet } from '@angular/router';
import { createInjectableType, Xliff } from '@angular/compiler';
import { HttpClient, HttpClientModule } from '@angular/common/http';
import * as XLSX from 'xlsx';
@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule, RouterOutlet,HttpClientModule],
  templateUrl: './app.component.html',
  styleUrl: './app.component.css'
})
export class AppComponent implements OnInit {
  title = 'Products-APP';
  httpClient = inject(HttpClient);
  products:any = [];
  totalPages:any=[];
  fetchProducts(pageNo:number):void{
      this.httpClient.get('http://localhost:5058/Products/products/'+pageNo).subscribe((data:any)=>{
        this.products=data;
        console.log(this.products);
      });
  }
//thanks for watching this video...
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

}
