-- Library & Use Statements
LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- Entity Declaration 
ENTITY infrastructure IS
  PORT( 
		clk			:	IN		std_logic;
		reset_n		:	IN		std_logic;
		serdata_in	:	IN		std_logic;
		serdata_out :	OUT	std_logic
	);
END infrastructure;


-- Architecture Declaration 
ARCHITECTURE rtl OF infrastructure IS

	-- Signals & Constants Declaration 
	SIGNAL q1: std_logic;
	
-- Begin Architecture
BEGIN 

	 -------------------------------------------
    -- Process for registers (flip-flops)
    -------------------------------------------
	
	flip_flops : PROCESS(clk, reset_n, q1)
	BEGIN	
		IF reset_n = '0' THEN
			q1 			<= '0';
			serdata_out <= q1;
		ELSIF rising_edge(clk) THEN
			q1 			<= serdata_in;
			serdata_out <= q1;
		END IF;
	END PROCESS flip_flops;	
	
END rtl;	
