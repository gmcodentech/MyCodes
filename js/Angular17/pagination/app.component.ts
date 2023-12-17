import { Component,inject,OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterOutlet } from '@angular/router';
import { createInjectableType } from '@angular/compiler';
import { HttpClient, HttpClientModule } from '@angular/common/http';
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

  fetchProductTotalPages():void{
    this.httpClient.get('http://localhost:5058/Products/product_pages').subscribe((data)=>{
    this.totalPages = Array.from(Array(data),(_,i)=>i+1);
    });
  }

  ngOnInit():void{
    this.fetchProductTotalPages();
    this.fetchProducts(1);
  }
}
