/* Name: Akshaya Adlakha
   Batch: DI 18
   ---------------APB FSM CONTROLLER---------------
                                      
                                     Date:10/02/2022
RTL code:                                           */

module apb_controller(
input HCLK,HRESETn,Hwrite,valid,HwriteReg,
input [3:0]Temp_selx,
input [31:0] Haddr1,Haddr2,Haddr3,Hwdata1,Hwdata2,Hwdata3,Prdata,

output reg Pwrite,Penable,Hreadyout,
output reg [3:0] Pselx,
output reg [31:0] Paddr,Pwdata,
output [31:0] Hrdata,
output reg [1:0] Hresp);

parameter ST_IDLE= 3'b000, ST_READ= 3'b001, ST_RENABLE=3'b010,ST_WWAIT=3'b011,
          ST_WRITE=3'b100, ST_WENABLE=3'b101, ST_WRITEP=3'b110,ST_WENABLEP=3'b111;
reg [2:0] ps, ns;


always @(posedge HCLK, negedge HRESETn)
  begin
    if(~HRESETn)
        ps<=ST_IDLE;
    else
        ps<=ns;
  end

// Combinational logic 
always@(*) begin
    ns= ST_IDLE;
  
     case(ps)
          ST_IDLE:begin
                   case({valid,Hwrite})
                          2'b11:ns=ST_WWAIT;
                          2'b10:ns=ST_READ;
                        default:ns=ST_IDLE;
                   endcase
                  end
                  
           ST_READ:begin
                    ns=ST_RENABLE;
                   end

           ST_RENABLE:begin
                       case({valid,Hwrite})
                             2'b11:ns=ST_WWAIT;
                             2'b10:ns=ST_READ;
                           default:ns=ST_IDLE;
                       endcase
                      end

            ST_WWAIT:begin
                       if(valid)
                        ns=ST_WRITEP;
                       else
                        ns=ST_WRITE;
                     end

             ST_WRITE:begin
                       if(valid)
                        ns=ST_WENABLEP;
                       else
                        ns=ST_WENABLE;
                      end  
           ST_WENABLE:begin
                       case({valid,Hwrite})
                             2'b11:ns=ST_WWAIT;
                             2'b10:ns=ST_READ;
                           default:ns=ST_IDLE;
                       endcase
                      end 
            ST_WRITEP:begin
                       ns=ST_WENABLEP;
                      end

           ST_WENABLEP:begin
                        case({valid,HwriteReg})  
                          2'b01:ns=ST_WRITE;
                          2'b10:ns=ST_READ;
                          2'b11:ns=ST_WRITEP;
                          default:ns=ST_IDLE;
                        endcase
                       end
      endcase
   end

// reg output logic
always@(posedge HCLK, negedge HRESETn)
  begin
    if(~HRESETn)
        begin
          Pselx <= 4'd0;
          Pwrite <= 1'b0;
          Hreadyout<=1'b0;
          Paddr<=32'd0;
          Pwdata<=32'd0;
          Penable<=1'b0;
          Hresp<=2'd0;
        end
     else
        begin
          Pselx<=Temp_selx;
          Hreadyout<=1'b0;
          Penable<=1'b0;
          Pwrite<=1'b0;
          Hresp<=2'd0;
        case(ps)
            ST_IDLE:begin
                      Pselx<=4'd0;
                      Hreadyout<=1'b1;
                      Penable<=1'b0;
                    end
            ST_READ:begin
                       Pselx<=Temp_selx;
                       Hreadyout<=1'b0;
                       Penable<=1'b0;
                       Pwrite<=1'b0;
                       Paddr<=Haddr1;
                     end
           
          ST_RENABLE:begin
                       Hreadyout<=1'b1;
                       Penable<=1'b1;
                       Pwrite<=1'b0;
                     end
         
            ST_WRITE:begin
                       Pselx<=Temp_selx;
                       Hreadyout<=1'b0;
                       Penable<=1'b0;
                       Pwrite<=1'b1;
                       Paddr<=Haddr2;
                       Pwdata<=Hwdata1;
                     end
               
            ST_WWAIT:begin
                       Pselx<=4'd0;
                       Hreadyout<=1'b0;
                       Penable<=1'b0;
                       Pwrite<=1'b0;
                     end
                
            ST_WENABLE:begin
                       Hreadyout<=1'b1;
                       Penable<=1'b1;
                       Pwrite<=1'b1;
                     end
               
            ST_WRITEP:begin
                       Pselx<=Temp_selx;
                       Hreadyout<=1'b0;
                       Penable<=1'b0;
                       Pwrite<=1'b1;
                       Paddr<=Haddr2;
                       Pwdata<=Hwdata1;
                     end      
                
         ST_WENABLEP:begin
                       Hreadyout<=1'b1;
                       Penable<=1'b1;
                       Pwrite<=1'b1;
                     end     
             default:begin
                       Hreadyout<=1'b0;
                       Penable<=1'b0;
                       Pwrite<=1'b0;
                       Paddr<=32'd0;
                       Pwdata<=32'd0;
                      end
        endcase
      end
   end

assign Hrdata=Prdata;
endmodule            
                      


 

                     

