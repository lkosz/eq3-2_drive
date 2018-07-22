
## Have to buy: ##

* Stepper motor: 
  * Choose with lowest coil resistance and lowest design voltage
  * tourque about 3Nm or greater
* Display: 7-segment driven by TM1637
* Motor driver:
  * recommended with 1/16, 1/32 or 1/128 step resolution
  * have to provide at least design current of motor
  * have to tolerate at least 2x of motor design voltage, recommended 10x
* Arduino: Leonardo-compatible is enough, I used Blue Pro Micro
* Other:
  * 5 monostable lever switch, type: ON-OFF-ON
  * 1 rotary switch with 3 positions
  * copper cable:
    * few meters to connect driver to power supply (depends on current)
    * few meters to connect driver to stepper motor (depends on current, 0,5mm^2 should be enough in most cases)
  * 2 banana plug for power supply
  * 1 DIN-5 socket and plug
  * 1 zener diode 2-3V
  * 6 general purpose silicon diode with low reverse current
  * 6 ceramic capacitors (not necessary)

## Schema: ##

