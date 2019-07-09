# 1. PCA 9685 PWM Motor Drive:
**[Datasheet](https://cdn-shop.adafruit.com/datasheets/PCA9685.pdf)**  
[Detail Implementation](https://learn.adafruit.com/16-channel-pwm-servo-driver/chaining-drivers)  
[PCA 9685 and HAL](https://simonmartin.ch/resources/stm32/dl/STM32%20Tutorial%2004%20-%20I2C%20Module%20(pca9685)%20using%20HAL%20(and%20FreeRTOS).pdf)  
[PCA 9685 Documents](https://cdn-learn.adafruit.com/downloads/pdf/16-channel-pwm-servo-driver.pdf)  

## 1.1 GPIO Pin Wire
| STM32F3 GPIO  | PCA 9685 GPIO | Note        |
| ------------- | ------------- | ----------- |
| 5V            | VCC           |             |
| GND           | GND           |             |
| PA9           | SCL           | I2C2 SCL    |
| PA10          | SDA           | I2C2 SDA    |
