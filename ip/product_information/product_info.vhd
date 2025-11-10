library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_UNSIGNED.all;

						
entity product_info is
	port (
		clk: in std_logic;
		reset_n : in std_logic;
		
		chipselect_n : in std_logic; -- chip select signal
		read_n : in std_logic; -- output enable
		av_address : in std_logic_vector(1 downto 0);
		av_data_read : out std_logic_vector(31 downto 0)
		
	);
end product_info;

architecture rtl of product_info is
--  project name with 4 chars in hex use upper case if possible
--  constant sof : std_logic_vector(31 downto 0):=x"4750494F";       -- GPIO project
--  constant sof : std_logic_vector(31 downto 0):=x"50434945";       -- PCIE project 
--  constant sof : std_logic_vector(31 downto 0):=x"464d4341";       -- FMCA project
--  constant sof : std_logic_vector(31 downto 0):=x"464d4342";       -- FMCB project
--  constant sof : std_logic_vector(31 downto 0):=x"44445233";       -- DDR3 project
--  constant sof : std_logic_vector(31 downto 0):=x"44445234";       -- DDR4 project
--  constant sof : std_logic_vector(31 downto 0):=x"524C4452";       -- RLDR project
--  constant sof : std_logic_vector(31 downto 0):=x"51445234";       -- QDR4 project
--  constant sof : std_logic_vector(31 downto 0):=x"58435652";       -- XCVR project
--  constant sof : std_logic_vector(31 downto 0):=x"58435634";       -- XCV4 project 
--  constant sof : std_logic_vector(31 downto 0):=x"50414d34";       -- PAM4 project
    constant sof : std_logic_vector(31 downto 0):=x"51534650";       -- QSFPDD NRZ project

--  constant board : std_logic_vector(31 downto 0):=x"53344754";     -- S4GT
--  constant board : std_logic_vector(31 downto 0):=x"53355349";     -- S5SI
--  constant board : std_logic_vector(31 downto 0):=x"41354758";     -- A5GX 
--  constant board : std_logic_vector(31 downto 0):=x"41354754";     -- A5GT
--  constant board : std_logic_vector(31 downto 0):=x"41414758";     -- AAGX - Arria 10 GX
--  constant board : std_logic_vector(31 downto 0):=x"41415358";     -- AASX - Arria 10 SoC
--  constant board : std_logic_vector(31 downto 0):=x"53414C54";     -- SALT - Stratix 10 L-Tile
--  constant board : std_logic_vector(31 downto 0):=x"53414554";     -- SAET - Stratix 10 E-Tile
--  constant board : std_logic_vector(31 downto 0):=x"41474642";     -- AGFB - Agilex FB devkit
--  constant board : std_logic_vector(31 downto 0):=x"41474938";     -- AGIx - Agilex-I devkit
    constant board : std_logic_vector(31 downto 0):=x"41475349";     -- AGISX - Agilex-F devkit
	
--  constant product : std_logic_vector(31 downto 0):=x"0000A862";   -- 43106  S4GT100G host kit
--  constant product : std_logic_vector(31 downto 0):=x"0000AB46";   -- 43846  S5SI Demo Board - GX Version
--  constant product : std_logic_vector(31 downto 0):=x"0000AC41";   -- 44097  S5SI Demo Board - GT Version
--  constant product : std_logic_vector(31 downto 0):=x"0000AC40";   -- 44096  A5GX Dev Kit Demo Board
--  constant product : std_logic_vector(31 downto 0):=x"0000AC84";   -- 44164  A5GT Dev Kit Demo Board
--  constant product : std_logic_vector(31 downto 0):=x"0000ACC9";   -- 44233  A10 FPGA Dev Kit   
--  constant product : std_logic_vector(31 downto 0):=x"0000ACCB";   -- 44235  A10 SI Dev Kit   
--  constant product : std_logic_vector(31 downto 0):=x"0000AD5E";   -- 44382  A10 SOC Dev Kit 
--  constant product : std_logic_vector(31 downto 0):=x"0000AD7A";   -- 44410  S10 SI L-Tile/H-Tile Dev KIt
--  constant product : std_logic_vector(31 downto 0):=x"0000ADEE";   -- 44526  S10 SI TX Dev KIt
--  constant product : std_logic_vector(31 downto 0):=x"000139A2";   -- 80290  Agilex FB EN devkit
--  constant product : std_logic_vector(31 downto 0):=x"0000443F";   -- 17471  Agilex-I FPGA Dev Kit
    constant product : std_logic_vector(31 downto 0):=x"00012728";   -- 57542  Agilex-F FPGA Dev Kit
	
    constant version : std_logic_vector(31 downto 0):=x"00000001";   -- version << whatever you decide this number    



begin

	process(reset_n, clk)begin
		if(reset_n = '0')then
			av_data_read <= (others => '0');
		elsif(clk'event and clk = '1')then
			if(chipselect_n = '0' and read_n = '0')then
				case av_address is
					when "00" => av_data_read <= product;
					when "01" => av_data_read <= board;
					when "10" => av_data_read <= sof;
					when "11" => av_data_read <= version;
					when others => av_data_read <= (others => '0');
				end case;
			end if;
		end if;
	end process;
end rtl;

