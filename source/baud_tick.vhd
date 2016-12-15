-- Library & Use Statements
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

-- Entity Declaration 
ENTITY baud_tick IS
  PORT( 
		clk			:	IN		std_logic;
		baud_tick	:	OUT	std_logic;
		reset_n		:	IN		std_logic;
		start_bit   :	in		std_logic
	);
END baud_tick;


-- Architecture Declaration 
ARCHITECTURE rtl OF baud_tick IS
	
	CONSTANT	period 						:	unsigned(9 downto 0) := to_unsigned(434, 9); 
	CONSTANT	init_period		 			:	unsigned(9 downto 0) := to_unsigned(651, 9); 
	CONSTANT init_cntdown				:  unsigned(3 downto 0) := to_unsigned(7, 4);
	SIGNAL 	count, next_count			:	unsigned(9 downto 0);
	SIGNAL   cntdown, next_cntdown	:  unsigned(3 downto 0); 
	
-- Begin Architecture
BEGIN 


	-- input logic for baud tick
	input_logic: PROCESS(count, start_bit)
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

	END PROCESS input_logic;   

	-- baud tick period countdown
	baud_flip_flops : PROCESS(clk, reset_n)
	BEGIN	
		IF reset_n = '0' THEN
			count <= init_period;
		ELSIF rising_edge(clk) THEN
			count <= next_count;
		END IF;
	END PROCESS baud_flip_flops;	
	
	-- baud tick output logic
	output_logic: PROCESS(count)
	BEGIN
		IF (count = 0 AND cntdown > 0) THEN
			baud_tick <= '1';
		ELSE
			baud_tick <= '0';
		END IF;
		
	END PROCESS output_logic;
	
	-- byte countdown logic
	countdown_logic: PROCESS(start_bit, count, cntdown)
	BEGIN
		IF (start_bit = '1') THEN
			next_cntdown <= init_cntdown;
		ELSIF (count = 0 AND cntdown > 0) THEN
			next_cntdown <= cntdown - 1;
		ELSIF (count = 0 AND cntdown = 0) THEN
			next_cntdown <= to_unsigned(0, 4);
		END IF;
	END PROCESS countdown_logic;
	
	-- byte countdown flip flops
	countdown_flop_flops: PROCESS(clk, count, reset_n)
	BEGIN
		IF reset_n = '0' THEN
			cntdown <= to_unsigned(0, 4);
		ELSIF rising_edge(clk) THEN
			cntdown <= next_cntdown;
		END IF;
	END PROCESS countdown_flop_flops;
	
END rtl;	
