	component ftile_xcvr_test_xcvr_conduit_ctrl_0 is
		port (
			reset_n            : in  std_logic                     := 'X';             -- reset_n
			clk                : in  std_logic                     := 'X';             -- clk
			csr_address        : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- address
			csr_read           : in  std_logic                     := 'X';             -- read
			csr_write          : in  std_logic                     := 'X';             -- write
			csr_readdata       : out std_logic_vector(31 downto 0);                    -- readdata
			csr_writedata      : in  std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			tx_pll_locked      : in  std_logic_vector(0 downto 0)  := (others => 'X'); -- tx_pll_locked
			rx_is_lockedtoref  : in  std_logic_vector(0 downto 0)  := (others => 'X'); -- rx_is_lockedtoref
			rx_is_lockedtodata : in  std_logic_vector(0 downto 0)  := (others => 'X'); -- rx_is_lockedtodata
			tx_reset           : out std_logic_vector(0 downto 0);                     -- tx_reset
			tx_reset_ack       : in  std_logic_vector(0 downto 0)  := (others => 'X'); -- tx_reset_ack
			tx_ready           : in  std_logic_vector(0 downto 0)  := (others => 'X'); -- tx_ready
			rx_reset           : out std_logic_vector(0 downto 0);                     -- rx_reset
			rx_reset_ack       : in  std_logic_vector(0 downto 0)  := (others => 'X'); -- rx_reset_ack
			rx_ready           : in  std_logic_vector(0 downto 0)  := (others => 'X')  -- rx_ready
		);
	end component ftile_xcvr_test_xcvr_conduit_ctrl_0;

	u0 : component ftile_xcvr_test_xcvr_conduit_ctrl_0
		port map (
			reset_n            => CONNECTED_TO_reset_n,            --              reset.reset_n
			clk                => CONNECTED_TO_clk,                --              clock.clk
			csr_address        => CONNECTED_TO_csr_address,        --                csr.address
			csr_read           => CONNECTED_TO_csr_read,           --                   .read
			csr_write          => CONNECTED_TO_csr_write,          --                   .write
			csr_readdata       => CONNECTED_TO_csr_readdata,       --                   .readdata
			csr_writedata      => CONNECTED_TO_csr_writedata,      --                   .writedata
			tx_pll_locked      => CONNECTED_TO_tx_pll_locked,      --      tx_pll_locked.tx_pll_locked
			rx_is_lockedtoref  => CONNECTED_TO_rx_is_lockedtoref,  --  rx_is_lockedtoref.rx_is_lockedtoref
			rx_is_lockedtodata => CONNECTED_TO_rx_is_lockedtodata, -- rx_is_lockedtodata.rx_is_lockedtodata
			tx_reset           => CONNECTED_TO_tx_reset,           --           tx_reset.tx_reset
			tx_reset_ack       => CONNECTED_TO_tx_reset_ack,       --       tx_reset_ack.tx_reset_ack
			tx_ready           => CONNECTED_TO_tx_ready,           --           tx_ready.tx_ready
			rx_reset           => CONNECTED_TO_rx_reset,           --           rx_reset.rx_reset
			rx_reset_ack       => CONNECTED_TO_rx_reset_ack,       --       rx_reset_ack.rx_reset_ack
			rx_ready           => CONNECTED_TO_rx_ready            --           rx_ready.rx_ready
		);

