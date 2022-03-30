/* Name: Akshaya Adlakha
   Batch: DI 18
   -------------------BRIDGE TOP-------------------
                                      
                                     Date:17/02/2022
RTL code:                                           */

module bridge_top(
input hclk, hresetn, hreadyin, hwrite,
input [1:0] htrans,
input [31:0] haddr, hwdata, prdata,
output pwrite,penable,hreadyout,
output [1:0] hresp,
output [2:0] pselx,
output [31:0] pwdata, paddr, hrdata);

wire  valid,hwrite_reg1,hwrite_reg2,hwriteReg;
wire [2:0] temp_selx;
wire [31:0] hwdata1,hwdata2,hwdata3,haddr1,haddr2,haddr3;

ahb_slave_interface AHB_Slave(.HRESETn(hresetn),.Hwrite(hwrite),.HCLK(hclk),.Htrans(htrans),.Haddr(haddr),.Haddr1(haddr1),
                              .Haddr2(haddr2),.Haddr3(haddr3),.Hwdata(hwdata),.Hwdata1(hwdata1),.Hwdata2(hwdata2),.Hwdata3(hwdata3),.Hwrite_reg1(hwrite_reg1),.Hwrite_reg2(hwrite_reg2),
                              .Temp_selx(temp_selx),.valid(valid));

apb_controller APB_FSM(.HCLK(hclk),.HRESETn(hresetn),.Hwrite(hwrite),.valid(valid),.HwriteReg(hwrite_reg1),.Temp_selx(temp_selx),
                       .Haddr1(haddr1),.Haddr2(haddr2),.Haddr3(haddr3),.Hwdata1(hwdata1),.Hwdata2(hwdata2),.Hwdata3(hwdata3),
                       .Prdata(prdata),.Pwrite(pwrite),.Penable(penable),.Hreadyout(hreadyout),.Pselx(pselx),.Paddr(paddr),
                       .Pwdata(pwdata),.Hrdata(hrdata),.Hresp(hresp));
endmodule
