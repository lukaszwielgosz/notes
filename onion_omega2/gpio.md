enable pwms
```
omega2-ctrl gpiomux set pwm0 pwm
omega2-ctrl gpiomux set pwm1 pwm
```

sample program
```
import onionGpio
import time
import os
import math

AIN1 = onionGpio.OnionGpio(14) #GPIO14
AIN1.setOutputDirection(0)

AIN2 = onionGpio.OnionGpio(15) #GPIO15
AIN2.setOutputDirection(0)

BIN1 = onionGpio.OnionGpio(16) #GPIO16
BIN1.setOutputDirection(0)

BIN2 = onionGpio.OnionGpio(17) #GPIO17
BIN2.setOutputDirection(0)

PWM_FREQ = 5000
# PWM_A - GPIO18
# PWM_B - GPIO19

def set_pwm(ch, duty, freq):
    os.system("onion pwm {} {} {}".format(ch,duty,freq))

def set_motorA(val):
    if val >= 0:
        AIN1.setValue(1)
        AIN2.setValue(0)

    else:
        AIN1.setValue(0)
        AIN2.setValue(1)

    set_pwm(0, abs(int(val*100)), PWM_FREQ)


def set_motorB(val):
    if val >= 0:
        BIN1.setValue(1)
        BIN2.setValue(0)

    else:
        BIN1.setValue(0)
        BIN2.setValue(1)

    set_pwm(1, abs(int(val*100)), PWM_FREQ)

def set_motors(A, B):
    set_motorA(A)
    set_motorB(B)

set_motors(0.5, 0)
time.sleep(2)
set_motors(0, 0.5)
time.sleep(2)
set_motors(-0.5, -0.5)
time.sleep(2)
set_motors(0, 0)

```