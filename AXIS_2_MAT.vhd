-- Converts PYNQ DMA data to Adafruit SSD
-- Currently runs on hard-coded values (64x32 LED matrix, and a 64-value stream (each value is an amplitude from 0 to 32))
-- A. Hallak, 1/23/2022

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.math_real.all;
use IEEE.numeric_std.all;


entity AXIS_2_MAT is
    Port ( s_axis_tdata     : in STD_LOGIC_VECTOR (31 downto 0);
           s_axis_tlast     : in STD_LOGIC;
           s_axis_tvalid    : in STD_LOGIC;
           s_axis_tready    : out STD_LOGIC;
           s_axis_aclk      : in STD_LOGIC;
           s_axis_aresetn   : in STD_LOGIC;
           R0               : out STD_LOGIC;
           G0               : out STD_LOGIC;
           B0               : out STD_LOGIC;
           R1               : out STD_LOGIC;
           G1               : out STD_LOGIC;
           B1               : out STD_LOGIC;
           OE               : out STD_LOGIC;
           LAT              : out STD_LOGIC;
           MATCLK_i         : in STD_LOGIC;
           MATCLK_o         : out STD_LOGIC;
           A                : out STD_LOGIC;
           B                : out STD_LOGIC;
           C                : out STD_LOGIC;
           D                : out STD_LOGIC;
           blu,red,grn      : out STD_LOGIC;
           btn              : in STD_LOGIC;
           
           t_red15 : in STD_LOGIC_VECTOR(63 downto 0);
           t_red14 : in STD_LOGIC_VECTOR(63 downto 0);
           t_red13 : in STD_LOGIC_VECTOR(63 downto 0);
           t_red12 : in STD_LOGIC_VECTOR(63 downto 0);
           t_red11 : in STD_LOGIC_VECTOR(63 downto 0);
           t_red10 : in STD_LOGIC_VECTOR(63 downto 0);
           t_red9  : in STD_LOGIC_VECTOR(63 downto 0);
           t_red8  : in STD_LOGIC_VECTOR(63 downto 0);
           t_red7  : in STD_LOGIC_VECTOR(63 downto 0);
           t_red6  : in STD_LOGIC_VECTOR(63 downto 0);
           t_red5  : in STD_LOGIC_VECTOR(63 downto 0);
           t_red4  : in STD_LOGIC_VECTOR(63 downto 0);
           t_red3  : in STD_LOGIC_VECTOR(63 downto 0);
           t_red2  : in STD_LOGIC_VECTOR(63 downto 0);
           t_red1  : in STD_LOGIC_VECTOR(63 downto 0);
           t_red0  : in STD_LOGIC_VECTOR(63 downto 0);
           t_grn15 : in STD_LOGIC_VECTOR(63 downto 0);
           t_grn14 : in STD_LOGIC_VECTOR(63 downto 0);
           t_grn13 : in STD_LOGIC_VECTOR(63 downto 0);
           t_grn12 : in STD_LOGIC_VECTOR(63 downto 0);
           t_grn11 : in STD_LOGIC_VECTOR(63 downto 0);
           t_grn10 : in STD_LOGIC_VECTOR(63 downto 0);
           t_grn9  : in STD_LOGIC_VECTOR(63 downto 0);
           t_grn8  : in STD_LOGIC_VECTOR(63 downto 0);
           t_grn7  : in STD_LOGIC_VECTOR(63 downto 0);
           t_grn6  : in STD_LOGIC_VECTOR(63 downto 0);
           t_grn5  : in STD_LOGIC_VECTOR(63 downto 0);
           t_grn4  : in STD_LOGIC_VECTOR(63 downto 0);
           t_grn3  : in STD_LOGIC_VECTOR(63 downto 0);
           t_grn2  : in STD_LOGIC_VECTOR(63 downto 0);
           t_grn1  : in STD_LOGIC_VECTOR(63 downto 0);
           t_grn0  : in STD_LOGIC_VECTOR(63 downto 0);
           t_blu15 : in STD_LOGIC_VECTOR(63 downto 0);
           t_blu14 : in STD_LOGIC_VECTOR(63 downto 0);
           t_blu13 : in STD_LOGIC_VECTOR(63 downto 0);
           t_blu12 : in STD_LOGIC_VECTOR(63 downto 0);
           t_blu11 : in STD_LOGIC_VECTOR(63 downto 0);
           t_blu10 : in STD_LOGIC_VECTOR(63 downto 0);
           t_blu9  : in STD_LOGIC_VECTOR(63 downto 0);
           t_blu8  : in STD_LOGIC_VECTOR(63 downto 0);
           t_blu7  : in STD_LOGIC_VECTOR(63 downto 0);
           t_blu6  : in STD_LOGIC_VECTOR(63 downto 0);
           t_blu5  : in STD_LOGIC_VECTOR(63 downto 0);
           t_blu4  : in STD_LOGIC_VECTOR(63 downto 0);
           t_blu3  : in STD_LOGIC_VECTOR(63 downto 0);
           t_blu2  : in STD_LOGIC_VECTOR(63 downto 0);
           t_blu1  : in STD_LOGIC_VECTOR(63 downto 0);
           t_blu0  : in STD_LOGIC_VECTOR(63 downto 0);
           b_red15 : in STD_LOGIC_VECTOR(63 downto 0);
           b_red14 : in STD_LOGIC_VECTOR(63 downto 0);
           b_red13 : in STD_LOGIC_VECTOR(63 downto 0);
           b_red12 : in STD_LOGIC_VECTOR(63 downto 0);
           b_red11 : in STD_LOGIC_VECTOR(63 downto 0);
           b_red10 : in STD_LOGIC_VECTOR(63 downto 0);
           b_red9  : in STD_LOGIC_VECTOR(63 downto 0);
           b_red8  : in STD_LOGIC_VECTOR(63 downto 0);
           b_red7  : in STD_LOGIC_VECTOR(63 downto 0);
           b_red6  : in STD_LOGIC_VECTOR(63 downto 0);
           b_red5  : in STD_LOGIC_VECTOR(63 downto 0);
           b_red4  : in STD_LOGIC_VECTOR(63 downto 0);
           b_red3  : in STD_LOGIC_VECTOR(63 downto 0);
           b_red2  : in STD_LOGIC_VECTOR(63 downto 0);
           b_red1  : in STD_LOGIC_VECTOR(63 downto 0);
           b_red0  : in STD_LOGIC_VECTOR(63 downto 0);
           b_grn15 : in STD_LOGIC_VECTOR(63 downto 0);
           b_grn14 : in STD_LOGIC_VECTOR(63 downto 0);
           b_grn13 : in STD_LOGIC_VECTOR(63 downto 0);
           b_grn12 : in STD_LOGIC_VECTOR(63 downto 0);
           b_grn11 : in STD_LOGIC_VECTOR(63 downto 0);
           b_grn10 : in STD_LOGIC_VECTOR(63 downto 0);
           b_grn9  : in STD_LOGIC_VECTOR(63 downto 0);
           b_grn8  : in STD_LOGIC_VECTOR(63 downto 0);
           b_grn7  : in STD_LOGIC_VECTOR(63 downto 0);
           b_grn6  : in STD_LOGIC_VECTOR(63 downto 0);
           b_grn5  : in STD_LOGIC_VECTOR(63 downto 0);
           b_grn4  : in STD_LOGIC_VECTOR(63 downto 0);
           b_grn3  : in STD_LOGIC_VECTOR(63 downto 0);
           b_grn2  : in STD_LOGIC_VECTOR(63 downto 0);
           b_grn1  : in STD_LOGIC_VECTOR(63 downto 0);
           b_grn0  : in STD_LOGIC_VECTOR(63 downto 0);
           b_blu15 : in STD_LOGIC_VECTOR(63 downto 0);
           b_blu14 : in STD_LOGIC_VECTOR(63 downto 0);
           b_blu13 : in STD_LOGIC_VECTOR(63 downto 0);
           b_blu12 : in STD_LOGIC_VECTOR(63 downto 0);
           b_blu11 : in STD_LOGIC_VECTOR(63 downto 0);
           b_blu10 : in STD_LOGIC_VECTOR(63 downto 0);
           b_blu9  : in STD_LOGIC_VECTOR(63 downto 0);
           b_blu8  : in STD_LOGIC_VECTOR(63 downto 0);
           b_blu7  : in STD_LOGIC_VECTOR(63 downto 0);
           b_blu6  : in STD_LOGIC_VECTOR(63 downto 0);
           b_blu5  : in STD_LOGIC_VECTOR(63 downto 0);
           b_blu4  : in STD_LOGIC_VECTOR(63 downto 0);
           b_blu3  : in STD_LOGIC_VECTOR(63 downto 0);
           b_blu2  : in STD_LOGIC_VECTOR(63 downto 0);
           b_blu1  : in STD_LOGIC_VECTOR(63 downto 0);
           b_blu0  : in STD_LOGIC_VECTOR(63 downto 0));
end AXIS_2_MAT;

architecture Behavioral of AXIS_2_MAT is

constant HORIZ_DATA : integer := 64;
constant HORIZ_DATA_div2 : integer := 32;
constant VERT_DATA  : integer := 16;
signal data_count   : integer := HORIZ_DATA_div2; -- HORIZ / 2;
signal countOnes    : integer := 0;
signal splice_count : integer := 0;

-- Buffers to write to display
type displayHorizBuf is array(0 to VERT_DATA-1) of STD_LOGIC_VECTOR(HORIZ_DATA-1 downto 0);
signal Rw0, Gw0, Bw0 : displayHorizBuf := (others => (others => '0'));
signal Rw1, Gw1, Bw1 : displayHorizBuf := (others => (others => '0'));
signal horiz_write_count : integer := HORIZ_DATA;
signal vert_write_count  : integer := VERT_DATA;
signal row_sel,row_sel_ff, row_sel_ff2: STD_LOGIC_VECTOR(3 downto 0) := (others=>'0');
signal hold_lat, unlatch : STD_LOGIC := '0';
signal rst_mat           : STD_LOGIC := '1';
signal OE_ff, LAT_ff,OE_ff2     : STD_LOGIC := '0';
signal row_up            : STD_LOGIC := '1';
signal unlatch_ff2, unlatch_ff       : STD_LOGIC := '0';

type STATE_TYPE is (INIT, READ, CONVERT, PARSE, WRITE);
signal state : STATE_TYPE := INIT;

type data is array(0 to HORIZ_DATA-1) of STD_LOGIC_VECTOR(15 downto 0);
signal tdata_msb, tdata_lsb : data := (others => (others => '0'));
type integers is array(0 to HORIZ_DATA-1) of integer;
signal bits_to_ints : integers := (others => 0);

type int_to_slv_arr is array(0 to HORIZ_DATA-1) of STD_LOGIC_VECTOR(VERT_DATA-1 downto 0);
signal int_to_slv : int_to_slv_arr := (others => (others => '0'));

signal mat_write_en, mat_write_en_ff1, mat_write_en_ff2 : STD_LOGIC := '0';
signal matclk_en, matclk_en_ff1, matclk_en_ff2 : STD_LOGIC := '0';

signal loops_done, mat_write_done : STD_LOGIC := '0';


signal TEST_INCREMENT : integers := (others => 0);
signal bigloop, smolloop : integer;

begin

process(s_axis_aclk) begin
    for i in 0 to HORIZ_DATA -1 loop
        TEST_INCREMENT(i) <= i;
    end loop; 
end process;
 --inout? IPI hates inouts...
A <= row_sel_ff2(0);
B <= row_sel_ff2(1);
C <= row_sel_ff2(2);
D <= row_sel_ff2(3);

process(s_axis_aclk) begin -- State machine controller
    if(matclk_en = '1') then
        MATCLK_o <= MATCLK_i;
    else
        MATCLK_o <= '0'; 
    end if;
    if(rising_edge(s_axis_aclk)) then
        if(s_axis_aresetn = '0') then
            state <= INIT;
        else
        case state is
            when INIT =>
                blu <= '1';
                red <= '1';
                grn <= '1';
                -- R0 <= '0';
                -- B0 <= '0';
                -- G0 <= '0';
                -- R1 <= '0';
                -- B1 <= '0';
                -- G1 <= '0';
                -- OE <= '1';
                -- LAT <= '0';
                -- A <= '0';
                -- B <= '0';
                -- C <= '0';
                -- D <= '0';
                tdata_msb <= (others => (others => '0'));
                tdata_lsb <= (others => (others => '0'));
                data_count <= HORIZ_DATA_div2;
                s_axis_tready <= '0';
                mat_write_en <= '0';
                mat_write_en_ff1 <= '0';
                mat_write_en_ff2 <= '0';
                bits_to_ints <= (others=>0);
                loops_done <= '0';
                smolloop <= 0;
                bigloop <= 63;
                state <= PARSE;
            when READ =>
                red <= '1';
                grn <= '0';
                blu <= '0';
                if(data_count > 0) then
                    s_axis_tready <= '1';
                    if(s_axis_tvalid = '1') then
                        tdata_msb(data_count-1) <= s_axis_tdata(31 downto 16);
                        tdata_lsb(data_count-1) <= s_axis_tdata(15 downto 0);
                        data_count <= data_count - 1;
                    end if;
                else
                    s_axis_tready <= '0';
                    report "now parsing...";
                    data_count <= HORIZ_DATA_div2;
                    splice_count <= 0;
                    state <= CONVERT;
                end if;
            when CONVERT =>
                red <= '0';
                grn <= '1';
                blu <= '0';
                for i in 0 to HORIZ_DATA-1 loop
                    if (i mod 2 = 0) then
                        bits_to_ints(i) <= to_integer(unsigned(tdata_msb(splice_count)));
                        bits_to_ints(i+1) <= to_integer(unsigned(tdata_lsb(splice_count)));
                        splice_count <= splice_count + 1;
                    end if;
                end loop;
                state <= PARSE;
            when PARSE =>
                splice_count <= 0;
                red <= '0';
                grn <= '0';
                blu <= '1';
                for i in 63 downto 0 loop
                    int_to_slv(i) <= std_logic_vector(to_unsigned(bits_to_ints(63-i), int_to_slv(i)'length));
                end loop;
                
--                for k in (64-1) downto 0 loop
--                    for i in (16-1) downto 0 loop
--                        Rw0(i)(k) <= int_to_slv(k)(i);
--                    end loop;
--                end loop;    
-- -- end removal of stuff for testing --         
                
                --LSB loop parser..support up to 16 LEDs (top of display)
--                for i in 63 downto 0 loop -- up to 64 bits per "Red 0" spot (HORIZONTAL - WHOLE DISPLAY)
--                    countOnes <= 0;
--                    for j in 0 to 15 loop -- 16 "Red 0" spots (VERTICAL - TOP HALF)
--                        if(countOnes < TEST_INCREMENT(15-j)) then -- change to bits_to_intit
--                            Rw0(j)(i) <= '1';
--                        else
--                            Rw0(j)(i) <= '0';
--                        end if;               
--                        countOnes <= countOnes + 1;      
--                    end loop;
--                    if(i = 0) then
--                        loops_done <= '1';
--                    else
--                        loops_done <= '0';
--                    end if;             
--                end loop;

                --smol loop starts at 0
                --big loop starts at 63
                -- if(bigloop >= 0) then 
                --     if(smolloop <= 15) then
                --         if(countOnes < 5) then --TEST_INCREMENT(15-smolloop)
                --             Rw0(smolloop)(bigloop) <= '1';
                --             countOnes <= countOnes + 1;
                --         else
                --             Rw0(smolloop)(bigloop) <= '0';
                --         end if;
                --         smolloop <= smolloop + 1;
                --     end if;
                --     if(smolloop = 15) then
                --         bigloop <= bigloop - 1;
                --         smolloop <= 0;
                --         countOnes <= 0;
                --     end if;
                -- else 
                --     loops_done <= '1';
                -- end if;
    Gw0(15) <= t_grn15;
    Gw0(14) <= t_grn14; 
    Gw0(13) <= t_grn13; 
    Gw0(12) <= t_grn12; 
    Gw0(11) <= t_grn11; 
    Gw0(10) <= t_grn10; 
    Gw0( 9) <= t_grn9 ; 
    Gw0( 8) <= t_grn8 ; 
    Gw0( 7) <= t_grn7 ; 
    Gw0( 6) <= t_grn6 ; 
    Gw0( 5) <= t_grn5 ; 
    Gw0( 4) <= t_grn4 ; 
    Gw0( 3) <= t_grn3 ; 
    Gw0( 2) <= t_grn2 ; 
    Gw0( 1) <= t_grn1 ; 
    Gw0( 0) <= t_grn0 ; 

    Rw0(15) <= t_red15; 
    Rw0(14) <= t_red14; 
    Rw0(13) <= t_red13; 
    Rw0(12) <= t_red12; 
    Rw0(11) <= t_red11; 
    Rw0(10) <= t_red10; 
    Rw0( 9) <= t_red9 ; 
    Rw0( 8) <= t_red8 ; 
    Rw0( 7) <= t_red7 ; 
    Rw0( 6) <= t_red6 ; 
    Rw0( 5) <= t_red5 ; 
    Rw0( 4) <= t_red4 ; 
    Rw0( 3) <= t_red3 ; 
    Rw0( 2) <= t_red2 ; 
    Rw0( 1) <= t_red1 ; 
    Rw0( 0) <= t_red0 ; 

    Bw0(15) <= t_blu15;
    Bw0(14) <= t_blu14;
    Bw0(13) <= t_blu13;
    Bw0(12) <= t_blu12;
    Bw0(11) <= t_blu11;
    Bw0(10) <= t_blu10;
    Bw0( 9) <= t_blu9 ;
    Bw0( 8) <= t_blu8 ;
    Bw0( 7) <= t_blu7 ;
    Bw0( 6) <= t_blu6 ;
    Bw0( 5) <= t_blu5 ;
    Bw0( 4) <= t_blu4 ;
    Bw0( 3) <= t_blu3 ;
    Bw0( 2) <= t_blu2 ;
    Bw0( 1) <= t_blu1 ;
    Bw0( 0) <= t_blu0 ;

    Rw1(15) <= b_red15;
    Rw1(14) <= b_red14;
    Rw1(13) <= b_red13;
    Rw1(12) <= b_red12;
    Rw1(11) <= b_red11;
    Rw1(10) <= b_red10;
    Rw1( 9) <= b_red9 ;
    Rw1( 8) <= b_red8 ;
    Rw1( 7) <= b_red7 ;
    Rw1( 6) <= b_red6 ;
    Rw1( 5) <= b_red5 ;
    Rw1( 4) <= b_red4 ;
    Rw1( 3) <= b_red3 ;
    Rw1( 2) <= b_red2 ;
    Rw1( 1) <= b_red1 ;
    Rw1( 0) <= b_red0 ;

    Bw1(15) <= b_blu15;
    Bw1(14) <= b_blu14;
    Bw1(13) <= b_blu13;
    Bw1(12) <= b_blu12;
    Bw1(11) <= b_blu11;
    Bw1(10) <= b_blu10;
    Bw1( 9) <= b_blu9 ;
    Bw1( 8) <= b_blu8 ;
    Bw1( 7) <= b_blu7 ;
    Bw1( 6) <= b_blu6 ;
    Bw1( 5) <= b_blu5 ;
    Bw1( 4) <= b_blu4 ;
    Bw1( 3) <= b_blu3 ;
    Bw1( 2) <= b_blu2 ;
    Bw1( 1) <= b_blu1 ;
    Bw1( 0) <= b_blu0 ;

    Gw1(15) <= b_grn15;
    Gw1(14) <= b_grn14;
    Gw1(13) <= b_grn13;
    Gw1(12) <= b_grn12;
    Gw1(11) <= b_grn11;
    Gw1(10) <= b_grn10;
    Gw1( 9) <= b_grn9 ;
    Gw1( 8) <= b_grn8 ;
    Gw1( 7) <= b_grn7 ;
    Gw1( 6) <= b_grn6 ;
    Gw1( 5) <= b_grn5 ;
    Gw1( 4) <= b_grn4 ;
    Gw1( 3) <= b_grn3 ;
    Gw1( 2) <= b_grn2 ;
    Gw1( 1) <= b_grn1 ;
    Gw1( 0) <= b_grn0 ;
    
    
                --if(loops_done = '1') then
                    state <= WRITE;
                --end if;
            when WRITE =>
                red <= '1';
                grn <= '1';
                blu <= '0';
                smolloop <= 0;
                bigloop <= 63;
                loops_done <= '0';
                state <= PARSE;
        end case;
        end if;
    end if;
end process;

process(MATCLK_i) begin -- State machine controller
    if(falling_edge(MATCLK_i)) then -- Change data falling edge
        row_sel_ff <= row_sel;
        row_sel_ff2 <= row_sel_ff;
        --OE_ff2 <= OE_ff;
        --OE <= OE_ff2; -- Didn't really try LAT ff with OE commented out.
        --LAT <= LAT_ff;
        if(state = INIT or state = READ) then
            hold_lat <= '0';
            unlatch <= '0';
            unlatch_ff <= '0';
            unlatch_ff2 <= '0';
            vert_write_count <= VERT_DATA;
            horiz_write_count <= HORIZ_DATA;
            OE <= '0';
            LAT <= '0';
            row_sel <= "1111";
            row_up <= '1';
            mat_write_done <= '0';
        else
            if(hold_lat = '1') then
                unlatch_ff2 <= '1'; -- Hold for another cycle? Maybe?
                unlatch_ff <= unlatch_ff2;
                unlatch <= unlatch_ff;
            end if;
            if(vert_write_count > 0) then
                if(horiz_write_count > 0) then
                    matclk_en <= '1';
                    R0 <= Rw0(vert_write_count-1)(horiz_write_count-1);
                    G0 <= Gw0(vert_write_count-1)(horiz_write_count-1);
                    B0 <= Bw0(vert_write_count-1)(horiz_write_count-1);
                    R1 <= Rw1(vert_write_count-1)(horiz_write_count-1);
                    G1 <= Gw1(vert_write_count-1)(horiz_write_count-1);
                    B1 <= Bw1(vert_write_count-1)(horiz_write_count-1);
                    horiz_write_count <= horiz_write_count - 1;
                else --horiz write count now zero
                    if(row_up = '1') then
                        row_sel <= row_sel + 1;
                        row_up <= '0';
                    end if;
                    R0 <= '0';
                    G0 <= '0';
                    R0 <= '0';
                    G0 <= '0';
                    B0 <= '0';
                    R1 <= '0';
                    G1 <= '0';
                    B1 <= '0';
                    matclk_en <= '0';
                    OE <= '1';
                    LAT <= '1';
                    hold_lat <= '1';
                    if(unlatch = '1') then
                        OE <= '0';
                        LAT <= '0';
                        horiz_write_count <= HORIZ_DATA;
                        vert_write_count <= vert_write_count - 1;
                        hold_lat <= '0';
                        unlatch <= '0';
                        unlatch_ff <= '0';
                        row_up <= '1';
                    end if; --end if unlatch = '1'
                end if; -- end if horiz write 
            else -- vert write now zero
                horiz_write_count <= HORIZ_DATA;
                vert_write_count <= VERT_DATA;
                mat_write_done <= '1';
                OE <= '0';
            end if;
        end if;
    end if;
end process;


end Behavioral;
