/* Name: Akshaya Adlakha
   Batch: DI 18
   ---------------AHB MASTER---------------
                                      
                                     Date:23/02/2022
RTL code:                                           */

module ahb_master(input HCLK,HRESETn,Hreadyout,
                  input [1:0] Hresp,
                  input [31:0] Hrdata,
                  output reg Hwrite,Hreadyin,
                  output reg [1:0]Htrans,
                  output reg [31:0] Haddr,Hwdata);
reg [2:0] Hsize,Hburst;

task singlewrite();
  begin
    @(posedge HCLK)
      #1;
      begin
      Htrans=2'b10;
      Hwrite=1'b1;
      Hreadyin=1'b1;
      Haddr=32'h80000001;
      Hburst=3'b000;
      end

    @(posedge HCLK)
      #1;
      begin
      Hwdata=32'h12314532;
      Htrans=2'b00;
      end
  end
endtask

task singleread();
  begin
     @(posedge HCLK)
     #1;
     begin
     Htrans=2'b10;
     Hwrite=1'b0;
     Haddr=32'h80000001;
     Hreadyin=1'b1;
    end

     @(posedge HCLK)
     #1;
     begin
     Htrans=2'b00;
     end
   end
 endtask
endmodule   