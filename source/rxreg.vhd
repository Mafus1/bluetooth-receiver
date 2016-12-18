-- Library & Use Statements
LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- Entity Declaration 
ENTITY rxreg IS
  PORT( 
			clk			: IN		std_logic;
			reset_n		: IN     std_logic;
			valid_data	: IN		std_logic;
			data_i	   : IN    	std_logic_vector(7 downto 0);
			data_0_l		: OUT		std_logic_vector(3 downto 0);
			data_0_m		: OUT		std_logic_vector(3 downto 0);
			data_1_l		: OUT		std_logic_vector(3 downto 0);
			data_1_m		: OUT		std_logic_vector(3 downto 0);
			data_2_l		: OUT		std_logic_vector(3 downto 0);
			data_2_m		: OUT		std_logic_vector(3 downto 0);
			data_3_l		: OUT		std_logic_vector(3 downto 0);
			data_3_m		: OUT		std_logic_vector(3 downto 0)
    	);
END rxreg;


-- Architecture Declaration 
ARCHITECTURE rtl OF rxreg IS

	-- Signals & Constants Declaration 
	SIGNAL 	data, next_data 	: std_logic_vector(31 downto 0) := x"00000000";
	CONSTANT	default_data		: std_logic_vector(31 downto 0) := x"00000000"; 
	
-- Begin Architecture
BEGIN 

	input_logic: PROCESS(data, valid_data, data_i)
	BEGIN
	
		-- add new data to the data bus
		IF valid_data = '1' THEN
			next_data(23 downto 0) <= data(31 downto 8);
			next_data(31 downto 24) <= data_i;
			
		-- else, dont touch the data bus
		ELSE
			next_data <= data;
			
		END IF;
		
	END PROCESS input_logic;

	flip_flops : PROCESS(clk, reset_n)
	BEGIN	
	
		IF reset_n = '0' THEN
			data <= default_data;
			
		ELSIF (rising_edge(clk)) THEN
			data <= next_data;
		END IF;
		
	END PROCESS flip_flops;	
	 
	
	output_logic: PROCESS(data)
	BEGIN
		-- register 0
		data_0_m <= data(31 downto 28);
		data_0_l <= data(27 downto 24);
		
		-- register 1
		data_1_m <= data(23 downto 20);
		data_1_l <= data(19 downto 16);
		
		-- register 2
		data_2_m <= data(15 downto 12);
		data_2_l <= data(11 downto 8);
		
		-- register 3
		data_3_m <= data(7 downto 4);
		data_3_l <= data(3 downto 0);
		
	END PROCESS output_logic;
	
END rtl;	
