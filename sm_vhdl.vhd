Library ieee;
Use ieee.std_logic_1164.all;

Entity sm_vhdl is
Port(d, r, clk : in  std_logic;
     Q1, Q0    : out std_logic);
End sm_vhdl ;

Architecture a of sm_vhdl is
  type possible_states is (S0, S1, S2, S3);
  signal state: possible_states := S0;
  signal d_delayed, r_delayed: std_logic ;
  signal dr: std_logic_vector (1 downto 0);
  signal Qs: std_logic_vector (1 downto 0);
Begin
  DELAY_INPUTS: Process(clk) Begin 
    if  (clk'event and clk = '1')  then
      d_delayed <= d ; r_delayed <= r ;
    End if;
  End Process ;

  dr <=   ( d and (not d_delayed) ) 
        & ( r and (not r_delayed) ) ;
		  
  MAIN: Process(clk) Begin
  if (clk'event and clk = '1') then
    case state is
      when S0 =>
        if dr = "10" then state <= S1;
        else state <= S0;      end if;
      when S1 =>
        if    dr = "10" then state <= S2;
        elsif dr = "01" then state <= S0; 
        else state <= S1;         end if;
      when S2 =>
        if    dr = "10" then state <= S3;
        elsif dr = "01" then state <= S1; 
        else state <= S2;         end if;
      when S3 =>
        if dr = "01" then state <= S2; 
        else state <= S3;      end if;
      End case;
    End if;
  End Process;
  
  With state select
    Qs <= "00" when S0, "01" when S1,
          "10" when S2, "11" when S3;
  Q1 <= Qs(1); Q0 <= Qs(0); 
End a;