-- Library & Use Statements
LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- Entity Declaration 
ENTITY shiftreg IS
  PORT( 
			clk			: IN		std_logic;
			baud_tick	: IN		std_logic;
			ser_data 	: IN     std_logic;
			reset_n		: IN     std_logic;
			start_bit	: IN		std_logic;
    	   wlkng_one  	: OUT    std_logic;
			par_data    : OUT    std_logic_vector(7 downto 0)
    	);
END shiftreg;


-- Architecture Declaration 
ARCHITECTURE rtl OF shiftreg IS

	-- Signals & Constants Declaration 
	SIGNAL 	data, next_data 	: std_logic_vector(8 downto 0);
	CONSTANT	default_data		: std_logic_vector(8 downto 0) := "100000000"; 
	
-- Begin Architecture
BEGIN 

	input_logic: PROCESS(data, start_bit, baud_tick, ser_data)
	BEGIN
	
		-- write the walking one, followed by zeros, when we receive a start bit
		IF start_bit = '1' THEN
			next_data <= default_data;
			
		-- shift the serial input to the par output, if we have a baud tick
		ELSIF baud_tick = '1' THEN
			next_data(7 downto 0) <= data(8 downto 1);
			next_data(8) <= ser_data;
			
		-- else, dont touch the flip flops
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
	
		par_data <= data(8 downto 1);
		wlkng_one <= data(0);
		
	END PROCESS output_logic;
	
END rtl;	
