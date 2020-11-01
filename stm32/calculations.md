## PWM servo
The easiest way is to set timer tick to 1us. Set prescaler in such way to get timer that counts with 1MHz period. Then you set timer counter to 19999 (not 20000 because it counts from 0) and into pwm register you put values between 1000 and 2000 which correspond to 1000 and 2000 microseconds. For example:

```
f_cpu = 100 [MHz] = 100000000 [Hz]
servo_signal_pwm_period = 20000 [us]

f_tim = 1 [MHz]
TIM_Period = 20000 - 1 = 19999
TIM_Prescaler = 100 - 1 = 99
```

