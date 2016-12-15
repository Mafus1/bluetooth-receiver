-- Library & Use Statements
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

-- Entity Declaration 
ENTITY boud_tick IS
  PORT( 
		clk			:	IN		std_logic;
		baud_tick	:	OUT	std_logic;
		reset_n		:	IN		std_logic;
		start_bit   :	in		std_logic
	);
END boud_tick;


-- Architecture Declaration 
ARCHITECTURE rtl OF boud_tick IS
	
	CONSTANT	period 				:	unsigned(9 downto 0) := to_unsigned(434,9); 
	CONSTANT	init_period		 	:	unsigned(9 downto 0) := to_unsigned(651,9); 
	SIGNAL 	count, next_count	:	unsigned(9 downto 0);
	
-- Begin Architecture
BEGIN 

	--------------------------------------------------
	-- PROCESS FOR COMBINATORIAL LOGIC
	--------------------------------------------------
	comb_logic: PROCESS(count, start_bit)
	BEGIN	
		IF (start_bit = '1') THEN
			next_count <= init_period;
	
		-- decrement
		ELSIF (count > 0) THEN
			next_count <= count - 1 ;

		-- start new period
		ELSE
			next_count <= period;
		END IF;

	END PROCESS comb_logic;   

	 -------------------------------------------
    -- Process for registers
    -------------------------------------------
	flip_flops : PROCESS(clk, reset_n)
	BEGIN	
		IF reset_n = '0' THEN
			count <= init_period;
		ELSIF rising_edge(clk) THEN
			count <= next_count;
		END IF;
	END PROCESS flip_flops;	
	
	--------------------------------------------------
	-- PROCESS FOR COMBINATORIAL LOGIC
	--------------------------------------------------
	comb_logic_out: PROCESS(count)
	BEGIN
		if(count = 0) THEN
			baud_tick <= '1';
		ELSE
			baud_tick <= '0';
		END IF;
		
	END PROCESS comb_logic_out;
	
END rtl;	
