--SPI Driver for ADCS7476
--Constant sampling as fast as the device can run. Expects a 20 MHz input clock for max operation @ 1MSPS
--
--August 2021, A. Hallak

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ADCS7476 is
    Port ( en           : in STD_LOGIC; --enable FSM
           rst          : in STD_LOGIC; --reset FSM
           SCLK         : in STD_LOGIC; --Input 20 MHz clk
           SDATA        : in STD_LOGIC; --Input serial data
           CS_n         : out STD_LOGIC; --Chip select
           SCLK_out     : out STD_LOGIC; --Output clock to IC
           SDATA_OUT    : out STD_LOGIC_VECTOR(15 downto 0); --Output parallel data
           dvalid       : out STD_LOGIC); --Valid data ready to tx on SDATA_OUT
end ADCS7476;

architecture Behavioral of ADCS7476 is

type STATE is (INIT, CS, READ, HOLD);
signal ST_CURR : STATE := INIT;

signal SDATA_i : STD_LOGIC := '0'; --current data bit
signal data_count : integer range 0 to 16 := 0; -- 16 data bits to increment through. First 4 bits null, ignore.
signal CS_n_flag : STD_LOGIC := '1';

begin

SCLK_out <= SCLK;

FSM: process(SCLK) begin
    if(rising_edge(SCLK)) then
        if(rst = '1') then --reset all to initial state
            ST_CURR <= INIT;
        else
            case ST_CURR is
                when INIT =>
                    CS_n <= '1';
                    SDATA_OUT <= (others => '0');
                    dvalid <= '0';
                    data_count <= 16;
                    ST_CURR <= CS;
                when CS =>
                    CS_n <= '0';
                    ST_CURR <= READ;
                when READ =>
                    if(data_count > 0) then
                        dvalid <= '0';
                        SDATA_OUT(data_count-1) <= SDATA;
                        data_count <= data_count - 1;
                    else    
                        CS_n <= '1';
                        dvalid <= '1';
                        ST_CURR <= HOLD;
                    end if;
                when HOLD =>
                    data_count <= 16;
                    CS_n <= '0';
                    ST_CURR <= READ;
                when OTHERS =>
            end case;  
        end if;     
   end if; 
   if(falling_edge(SCLK)) then

    end if;   
end process FSM;

end Behavioral;

------------------------------------------
--SIMULATION TESTBENCH BELOW
------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ADCS7476_sim is
end ADCS7476_sim;

architecture SIM of ADCS7476_sim is
component ADCS7476 is
Port (     en           : in STD_LOGIC; --enable FSM
           rst          : in STD_LOGIC; --reset FSM
           SCLK         : in STD_LOGIC; --Input 20 MHz clk
           SDATA        : in STD_LOGIC; --Input serial data
           CS_n         : out STD_LOGIC; --Chip select
           SCLK_out     : out STD_LOGIC; --Output clock to IC
           SDATA_OUT    : out STD_LOGIC_VECTOR(15 downto 0); --Output parallel data
           dvalid       : out STD_LOGIC); --Valid data ready to tx on SDATA_OUT
end component;

signal rst : std_logic;
signal SCLK_sim : std_logic := '0';
signal SDATA_OUT_sim : std_logic_vector(15 downto 0) := (others => '0');
signal CS_n_sim : std_logic := '1';
signal sim_dvalid : std_logic;

begin
    uut: ADCS7476 PORT MAP(
        en => '0',
        rst => rst,
        SCLK => SCLK_sim,
        SDATA => '1',
        CS_n => CS_n_sim,
        --SCLK_out => '0',
        SDATA_OUT => SDATA_OUT_sim,--,
        dvalid => sim_dvalid
    );
    SCLK_sim <= not SCLK_sim after 25ns;
    
    
    stim_proc: process begin
        wait for 5 ns;
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 10000000 ns;
    end process stim_proc;
        
end SIM;
