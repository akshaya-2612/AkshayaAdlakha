/* Name: Akshaya Adlakha
   Batch: DI 18
   ---------------AHB Slave Interface---------------
                                      
                                     Date:09/02/2022
RTL code:                                           */

module ahb_slave_interface(

input HCLK,HRESETn,Hwrite,Hreadyin,
input [1:0] Htrans,
input [31:0] Haddr, Hwdata,

output reg valid,
output reg Hwrite_reg1, Hwrite_reg2,
output reg [31:0] Haddr1,Haddr2,Haddr3,Hwdata1,Hwdata2,Hwdata3,
output reg [2:0] Temp_selx);

// Sequential logic for pipelining 
always@(posedge HCLK)
begin 
  if(HRESETn)
    begin 
    Haddr1  <=0;
    Haddr2  <=0;
    Haddr3  <=0;
    Hwdata1 <=0;
    Hwdata2 <=0;
    Hwdata3 <=0;
    end
  else
    begin 
    Haddr1  <= Haddr;
    Haddr2  <= Haddr1;
    Haddr3  <= Haddr2;
    Hwdata1 <= Hwdata;
    Hwdata2 <= Hwdata1;
    Hwdata3 <= Hwdata2;
    end
  end

 
// combinational logic to select one of three peripherals 
always @(*)
 begin
   Temp_selx=3'b000;
   if((Haddr>=32'h8000_0000)&&(Haddr<=32'h8400_0000))
      Temp_selx=3'b001;
   else if ((Haddr>=32'h8400_0000)&&(Haddr<=32'h8800_0000))
      Temp_selx=3'b010;
   else if ((Haddr>=32'h8800_0000)&&(Haddr<=32'h8c00_0000))
      Temp_selx=3'b100;
 end

// combinational logic to check valid signal conditions
always@(*)
begin 
   if (Hreadyin &&((Htrans==2'b01)||(Htrans==2'b11)&&(Haddr>=32'h8000_0000)&&(Haddr<32'h8c00_0000)))
      valid<=1;
   else 
      valid<=1;
end

// Sequential logic block for Hwrite_reg signals
always@(posedge HCLK)
begin
   if(HRESETn)
     begin
     Hwrite_reg1<=0;
     Hwrite_reg2<=0;
     end
   else
     begin
     Hwrite_reg1<=Hwrite;
     Hwrite_reg2<=Hwrite_reg1;
     end
end

endmodule








                
