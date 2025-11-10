	component ftile_xcvr_test_directphy_f_0 is
		port (
			rx_cdr_refclk_link        : in  std_logic                     := 'X';             -- clk
			tx_pll_refclk_link        : in  std_logic                     := 'X';             -- clk
			system_pll_clk_link       : in  std_logic_vector(0 downto 0)  := (others => 'X'); -- clk
			tx_reset                  : in  std_logic_vector(0 downto 0)  := (others => 'X'); -- tx_reset
			rx_reset                  : in  std_logic_vector(0 downto 0)  := (others => 'X'); -- rx_reset
			tx_reset_ack              : out std_logic_vector(0 downto 0);                     -- tx_reset_ack
			rx_reset_ack              : out std_logic_vector(0 downto 0);                     -- rx_reset_ack
			tx_ready                  : out std_logic_vector(0 downto 0);                     -- tx_ready
			rx_ready                  : out std_logic_vector(0 downto 0);                     -- rx_ready
			tx_coreclkin              : in  std_logic                     := 'X';             -- clk
			rx_coreclkin              : in  std_logic                     := 'X';             -- clk
			tx_clkout                 : out std_logic;                                        -- clk
			rx_clkout                 : out std_logic;                                        -- clk
			tx_serial_data            : out std_logic_vector(0 downto 0);                     -- tx_serial_data
			tx_serial_data_n          : out std_logic_vector(0 downto 0);                     -- tx_serial_data_n
			rx_serial_data            : in  std_logic_vector(0 downto 0)  := (others => 'X'); -- rx_serial_data
			rx_serial_data_n          : in  std_logic_vector(0 downto 0)  := (others => 'X'); -- rx_serial_data_n
			tx_pll_locked             : out std_logic_vector(0 downto 0);                     -- tx_pll_locked
			rx_is_lockedtodata        : out std_logic_vector(0 downto 0);                     -- rx_is_lockedtodata
			rx_is_lockedtoref         : out std_logic_vector(0 downto 0);                     -- rx_is_lockedtoref
			tx_parallel_data          : in  std_logic_vector(79 downto 0) := (others => 'X'); -- tx_parallel_data
			rx_parallel_data          : out std_logic_vector(79 downto 0);                    -- rx_parallel_data
			reconfig_xcvr_clk         : in  std_logic_vector(0 downto 0)  := (others => 'X'); -- clk
			reconfig_xcvr_reset       : in  std_logic_vector(0 downto 0)  := (others => 'X'); -- reset
			reconfig_xcvr_write       : in  std_logic_vector(0 downto 0)  := (others => 'X'); -- write
			reconfig_xcvr_read        : in  std_logic_vector(0 downto 0)  := (others => 'X'); -- read
			reconfig_xcvr_address     : in  std_logic_vector(17 downto 0) := (others => 'X'); -- address
			reconfig_xcvr_byteenable  : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- byteenable
			reconfig_xcvr_writedata   : in  std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			reconfig_xcvr_readdata    : out std_logic_vector(31 downto 0);                    -- readdata
			reconfig_xcvr_waitrequest : out std_logic_vector(0 downto 0)                      -- waitrequest
		);
	end component ftile_xcvr_test_directphy_f_0;

	u0 : component ftile_xcvr_test_directphy_f_0
		port map (
			rx_cdr_refclk_link        => CONNECTED_TO_rx_cdr_refclk_link,        --  rx_cdr_refclk_link.clk
			tx_pll_refclk_link        => CONNECTED_TO_tx_pll_refclk_link,        --  tx_pll_refclk_link.clk
			system_pll_clk_link       => CONNECTED_TO_system_pll_clk_link,       -- system_pll_clk_link.clk
			tx_reset                  => CONNECTED_TO_tx_reset,                  --            tx_reset.tx_reset
			rx_reset                  => CONNECTED_TO_rx_reset,                  --            rx_reset.rx_reset
			tx_reset_ack              => CONNECTED_TO_tx_reset_ack,              --        tx_reset_ack.tx_reset_ack
			rx_reset_ack              => CONNECTED_TO_rx_reset_ack,              --        rx_reset_ack.rx_reset_ack
			tx_ready                  => CONNECTED_TO_tx_ready,                  --            tx_ready.tx_ready
			rx_ready                  => CONNECTED_TO_rx_ready,                  --            rx_ready.rx_ready
			tx_coreclkin              => CONNECTED_TO_tx_coreclkin,              --        tx_coreclkin.clk
			rx_coreclkin              => CONNECTED_TO_rx_coreclkin,              --        rx_coreclkin.clk
			tx_clkout                 => CONNECTED_TO_tx_clkout,                 --           tx_clkout.clk
			rx_clkout                 => CONNECTED_TO_rx_clkout,                 --           rx_clkout.clk
			tx_serial_data            => CONNECTED_TO_tx_serial_data,            --      tx_serial_data.tx_serial_data
			tx_serial_data_n          => CONNECTED_TO_tx_serial_data_n,          --    tx_serial_data_n.tx_serial_data_n
			rx_serial_data            => CONNECTED_TO_rx_serial_data,            --      rx_serial_data.rx_serial_data
			rx_serial_data_n          => CONNECTED_TO_rx_serial_data_n,          --    rx_serial_data_n.rx_serial_data_n
			tx_pll_locked             => CONNECTED_TO_tx_pll_locked,             --       tx_pll_locked.tx_pll_locked
			rx_is_lockedtodata        => CONNECTED_TO_rx_is_lockedtodata,        --  rx_is_lockedtodata.rx_is_lockedtodata
			rx_is_lockedtoref         => CONNECTED_TO_rx_is_lockedtoref,         --   rx_is_lockedtoref.rx_is_lockedtoref
			tx_parallel_data          => CONNECTED_TO_tx_parallel_data,          --    tx_parallel_data.tx_parallel_data
			rx_parallel_data          => CONNECTED_TO_rx_parallel_data,          --    rx_parallel_data.rx_parallel_data
			reconfig_xcvr_clk         => CONNECTED_TO_reconfig_xcvr_clk,         --   reconfig_xcvr_clk.clk
			reconfig_xcvr_reset       => CONNECTED_TO_reconfig_xcvr_reset,       -- reconfig_xcvr_reset.reset
			reconfig_xcvr_write       => CONNECTED_TO_reconfig_xcvr_write,       --  reconfig_xcvr_avmm.write
			reconfig_xcvr_read        => CONNECTED_TO_reconfig_xcvr_read,        --                    .read
			reconfig_xcvr_address     => CONNECTED_TO_reconfig_xcvr_address,     --                    .address
			reconfig_xcvr_byteenable  => CONNECTED_TO_reconfig_xcvr_byteenable,  --                    .byteenable
			reconfig_xcvr_writedata   => CONNECTED_TO_reconfig_xcvr_writedata,   --                    .writedata
			reconfig_xcvr_readdata    => CONNECTED_TO_reconfig_xcvr_readdata,    --                    .readdata
			reconfig_xcvr_waitrequest => CONNECTED_TO_reconfig_xcvr_waitrequest  --                    .waitrequest
		);

