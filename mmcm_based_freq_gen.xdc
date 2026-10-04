set_property PACKAGE_PIN E3 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 -name sys_clk [get_ports clk]

set_property PACKAGE_PIN C17 [get_ports out]
set_property IOSTANDARD LVCMOS33 [get_ports out]

set_property PACKAGE_PIN H17 [get_ports locked_led]
set_property IOSTANDARD LVCMOS33 [get_ports locked_led]
