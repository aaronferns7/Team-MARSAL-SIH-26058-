# Team-MARSAL-SIH-26058-

# FPGA Signal Generation

SIH26058 — Team MARSAL
Adaptive Sonar Transmitter Payload for AUVs

## What's here

Two ways to generate a frequency on the FPGA, built and tested on a
Nexys A7-100T, checked on a Tektronix DSO.

- `counter_based_freq_gen.v` — a counter toggles the output directly.
  You can set both frequency and duty cycle.
- `mmcm_based_freq_gen.v` — uses the FPGA's MMCM (clock management
  hardware) to multiply/divide the 100MHz board clock into a new
  frequency. Fixed output once synthesized, but much cleaner at
  higher frequencies.

## Why both

Counter-based is simple and lets you dial in any duty cycle, but at
high frequencies there aren't enough clock ticks per period to keep
good duty-cycle resolution. MMCM gives a clean, high-frequency clock
using dedicated hardware, but you can't change its duty cycle at
runtime the way you can with the counter version.

## How this connects to the actual project

The real system needs to transmit shaped sonar pulses (chirps etc.)
through a DAC, not just a plain square wave. These two files are the
first step toward that — making sure we can reliably get the FPGA to
produce controllable, precisely timed signals at all, on real
hardware, before adding the DAC, ADC, LUT and feedback logic on top.
The square wave here is a stand-in for the waveform core; the timing
and clocking lessons from this carry over directly once that core
gets replaced with actual pulse/chirp generation.

## Counter-based: how to use

Edit in `top`:
```verilog
generation #(
    .FREQ_HZ (1000),
    .DUTY_PCT(50)
) u_gen ( ... );
```
Works well from about 1Hz up to a few MHz. Above that, duty cycle
resolution gets coarse — e.g. at 1MHz you only get 1% steps, at
10MHz only 10% steps, since there just aren't many clock ticks left
per period.

Pins: `clk` -> E3, `rst` -> N17, `out` -> C17 (change to whatever
pin you're probing).

## MMCM-based: how to use

Edit inside `clk_gen`:
```verilog
.CLKFBOUT_MULT_F  (12.0),
.CLKOUT0_DIVIDE_F (3.0),
```
Output = `100MHz * MULT / (DIVCLK * DIVIDE)`. Keep the internal VCO
frequency (`100MHz * MULT / DIVCLK`) inside the Artix-7's valid MMCM
range (see UG472) — picking values outside that range gave us
unstable/wrong output on the scope when we tried it.

Pins: `clk` -> E3, `out` -> C17, `locked_led` -> H17 (lights when
the MMCM has locked — check this before trusting the scope reading).

## Tools

Vivado (Verilog), Tektronix DSO for verification.

## References

- R. P. Hodges, *The Sonar Equations* (2010)
- Guan et al. (2019), *Optimal Waveform Design Using Frequency-Modulated Pulse Trains for Active Sonar*
- AMD/Xilinx UG472, *7 Series FPGAs Clocking Resources*
- Digilent, *Nexys A7 FPGA Board Reference Manual*
