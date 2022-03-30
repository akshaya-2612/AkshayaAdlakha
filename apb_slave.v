/* Name: Akshaya Adlakha
   Batch: DI 18
   ---------------APB SLAVE---------------
                                      
                                     Date:23/02/2022
RTL code:                                           */

module apb_slave(input Pwrite,Penable,
                 input [2:0]Pselx,
                 input [31:0] Paddr,Pwdata,
                 output PwriteOut,PenableOut,
                 output [2:0]PselxOut,
                 output [31:0] PaddrOut,PwdataOut,
                 output reg [31:0]Prdata);

assign PwriteOut= Pwrite;
assign PenableOut=Penable;
assign PselxOut=Pselx;
assign PaddrOut=Paddr;
assign PwdataOut=Pwdata;

always@(*)
  begin
   if(Penable && ~Pwrite)
   Prdata=$urandom;
   else
   Prdata=32'd0;
  end
endmodule
