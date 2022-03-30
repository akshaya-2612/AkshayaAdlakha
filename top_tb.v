/* Name: Akshaya Adlakha
   Batch: DI 18
   ---------AHB2APB BRIDGE TOP TESTBENCH-----------
                                      
                                     Date:25/02/2022
RTL code:                                           */

module top_tb();
 reg hclk,hresetn;
 wire hreadyout,hwrite,hreadyin;
 wire [1:0]htrans,hresp;
 wire [31:0] haddr,hwdata;
 wire [31:0]hrdata;
 wire penableOut,pwriteOut;
 wire [2:0]pselxOut,pselx;
 wire [31:0]paddr,paddrOut,pwdata,pwdataOut;
 wire [31:0]prdata;
 wire penable,pwrite;

 assign hrdata=prdata;

 ahb_master AHBM(hclk,hresetn,hreadyout,hresp,hrdata,hwrite,hreadyin,htrans,haddr,hwdata);
                      
 bridge_top DUT(hclk,hresetn,hreadyin,hwrite,htrans,haddr,hwdata,prdata,pwrite,penable,hreadyout,hresp,pselx,pwdata,paddr,hrdata);

 apb_slave APBS(pwrite,penable,pselx,paddr,pwdata,pwriteOut,penableOut,pselxOut,paddrOut,pwdataOut,prdata);
 
 initial 
 begin 
 hclk=0;
 forever #10 hclk=~hclk;
 end 

 task reset;
  begin 
   @(negedge hclk)
    hresetn = 1'b0;
   @(negedge hclk)
    hresetn = 1'b1;
   end 
 endtask

 initial 
   begin 
    reset;
    AHBM.singlewrite; 
    #200;  
   /* AHBM.singleread;
    #200;    */     
   end 
endmodule
