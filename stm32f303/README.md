# 1. PCA 9685 PWM Motor Drive:
[Detail Implementation](https://learn.adafruit.com/16-channel-pwm-servo-driver/chaining-drivers)  

## 1.1 GPIO Pin Wire
| STM32F3 GPIO  | PCA 9685 GPIO | Note|
| ------------- | ------------- | ----------- |
| 5V            | VCC           |             |
| GND           | GND           |             |
| PA9           | SCL           | I2C2 SCL    |
| PA10          | SDA           | I2C2 SDA    |
