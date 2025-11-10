/* Quartus Prime Version 24.2.0 Build 40 06/27/2024 SC Pro Edition */
JedecChain;
	FileRevision(JESD32A);
	DefaultMfr(6E);

	P ActionCode(Cfg)
		Device PartName(AGIC040R39AR0) Path("C:/Users/Haas1S/Downloads/agilex_xcvr/qsfp_xcvr_012_custom_25650.6/output_files/") File("bts_xcvr.sof") MfrSpec(OpMask(1));
	P ActionCode(Ign)
		Device PartName(10M16SA) MfrSpec(OpMask(0) SEC_Device(QSPI_2GB) Child_OpMask(1 0));

ChainEnd;

AlteraBegin;
	ChainType(JTAG);
AlteraEnd;
