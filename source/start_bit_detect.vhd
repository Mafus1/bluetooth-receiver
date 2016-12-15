-- Library & Use Statements
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

-- Entity Declaration 
ENTITY start_bit_detect IS
  PORT( 
		clk			:	IN		std_logic;
		baud_tick	:	IN		std_logic;
		reset_n		:	IN		std_logic;
		edge			:	IN		std_logic;
		start_bit   :	OUT	std_logic
	);
END start_bit_detect;


-- Architecture Declaration 
ARCHITECTURE rtl OF start_bit_detect IS
	
	CONSTANT	count_from 			:	unsigned(3 downto 0) := to_unsigned(8,4); 
	CONSTANT	count_to		 		:	unsigned(3 downto 0) := to_unsigned(0,4); 
	SIGNAL 	count, next_count	:	unsigned(3 downto 0);
	
-- Begin Architecture
BEGIN 
	--------------------------------------------------
	-- PROCESS FOR COMBINATORIAL LOGIC
	--------------------------------------------------
	comb_logic: PROCESS(count, edge, baud_tick)
	BEGIN	
		IF (count = count_to AND edge = '1') THEN
			next_count <= count_from;
	
		-- decrement
		ELSIF (count > count_to AND baud_tick = '1') THEN
			next_count <= count - 1 ;

		-- freezes
		ELSE
			next_count <= count;
		END IF;
	END PROCESS comb_logic;   
	
	comb_logic_out: PROCESS(count, edge)
	BEGIN
		if(count = count_to AND edge = '1') THEN
			start_bit <= '1';
		ELSE
			start_bit <= '0';
		END IF;
	END PROCESS comb_logic_out;

	 -------------------------------------------
    -- Process for registers
    -------------------------------------------
	flip_flops : PROCESS(clk, reset_n)
	BEGIN	
		IF reset_n = '0' THEN
			count <= count_to; -- convert integer value 0 to unsigned with 4bits
		ELSIF rising_edge(clk) THEN
			count <= next_count;
		END IF;
	END PROCESS flip_flops;	
	
END rtl;	
