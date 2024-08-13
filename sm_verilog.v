module sm_verilog (
    input  wire d, r, clk,
    output reg  Q1, Q0     );
  typedef enum reg [1:0] 
        {S0, S1, S2, S3} possible_states;
  possible_states state = S0;   
  reg d_delayed, r_delayed;
  reg [1:0] dr;
  
  always @(posedge clk) begin
    d_delayed <= d; r_delayed <= r; 
  end
  
  always @(*) begin
    dr[1] = d & ~d_delayed; 
    dr[0] = r & ~r_delayed; 
  end
  
  always @(posedge clk) begin
    case (state)
      S0: begin
        if (dr == 2'b10) state <= S1; 
        else state <= S0;             
      end
      S1: begin
        if (dr == 2'b10) state <= S2; 
        else if (dr == 2'b01) state <= S0; 
        else state <= S1;             
      end
      S2: begin
        if (dr == 2'b10) state <= S3; 
        else if (dr == 2'b01) state <= S1;
        else state <= S2; 
      end
      S3: begin
        if (dr == 2'b01) state <= S2; 
        else state <= S3; 
      end
    endcase
  end
 
  always @(*) begin
    case (state)
      S0: {Q1, Q0} = 2'b00; 
      S1: {Q1, Q0} = 2'b01; 
      S2: {Q1, Q0} = 2'b10; 
      S3: {Q1, Q0} = 2'b11; 
    endcase
  end
endmodule
