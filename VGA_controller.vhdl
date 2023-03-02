library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;



entity VGA_Controller is
    Port ( clk : in STD_LOGIC;
           Rin,Gin,Bin : in unsigned(3 downto 0);
           R : out unsigned (3 downto 0);
           G : out unsigned (3 downto 0);
           B : out unsigned (3 downto 0);
           Hsync : out STD_LOGIC :='0'; -- initialized to  1
           Vsync : out STD_LOGIC :='0'); -- initialized to 1
end VGA_Controller;



architecture Behavioral of VGA_Controller is



    signal clk_50,clk_25: std_logic :='0';
    constant T_FP_H: integer :=16;
    constant T_BP_H: integer :=48;
    constant T_PW_H: integer :=96;
    constant T_DISP_H: integer :=640;
    constant T_S_H: integer :=800;

    constant T_FP_V: integer :=8000;
    constant T_BP_V: integer :=23200;
    constant T_PW_V: integer :=1600;
    constant T_DISP_V: integer :=384000;
    constant T_S_V: integer :=416800;
     
    signal display_start_v,display_start_h : STD_LOGIC :='0';
    signal signal_v : STD_LOGIC;
begin



clk_div:
        process(clk,clk_50)
        begin
        if(rising_edge(clk)) then
            clk_50<= not clk_50;
        end if;
        if(rising_edge(clk_50)) then
            clk_25<= not clk_25;
        end if;
        end process;
H_sync_generation:
        process(clk_25)
            variable counter : integer :=0;
        begin
            
            -- H Sync
--            if(counter=T_PW_H) then
--                HSync<='1';
--            end if;
--            if(counter=T_PW_H+T_BP_H) then
--                display_start_h<='1';

--            end if;
            
--            if(counter=T_PW_H+T_BP_H+T_DISP_H) then
--                display_start_h<='0';

--            end if;
--            if(counter=T_S_H) then
--                Hsync<='0';
--                counter:=1;
--            end if;
            if(rising_edge(clk_25)) then
                 counter := counter + 1;
                 if(counter=T_PW_H) then
                     HSync<='1';
                 elsif(counter=T_PW_H+T_BP_H) then
                     display_start_h<='1';
                 elsif(counter=T_PW_H+T_BP_H+T_DISP_H) then
                     display_start_h<='0';
                 elsif(counter=T_S_H) then
                     Hsync<='0';
                     counter:=0;
                 end if;
            end if;
            
        end process;
        
        
V_sync_generation:
        process(clk_25)
            variable counter : integer :=0;
        begin
            -- V Sync
            if(rising_edge(clk_25)) then
                 counter := counter + 1;
                 if(counter=T_BP_V) then
                     display_start_v<='1';
                 elsif(counter=T_DISP_V+T_BP_V) then
                     display_start_v<='0';
                 elsif(counter=T_BP_V+T_DISP_V + T_FP_V) then
                     VSync<='0';
                 elsif(counter=T_BP_V+T_DISP_V + T_FP_V + T_PW_V) then
                     Vsync<='1';
                     counter:=0;
                 end if;
            end if;
        end process; 

display_logic:
    process(display_start_v,display_start_h)
    
    begin
        if(display_start_v='1' and display_start_h='1') then
            R<=Rin;
            G<=Gin;
            B<=Bin;
        else
            R<="0000";
            G<="0000";
            B<="0000";
        end if;       
    
    end process;
    
end Behavioral;
