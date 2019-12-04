#include <math.h>
#include "stm32f3xx_hal.h"

#define PCA9685_ADDRESS 0x80
#define PCA9685_REG_MODE1 0x00 // Mode1 Register Address
#define PCA9685_REG_PRESCALE 0xFE // PRE_SCALE Register Address - prescaler for PWM output frequency
#define PCA9685_REG_LED0_ON_L 0x06
#define PCA9685_FREQUENCY 50 // Frequency of entire chip, 24 Hz to 1526 Hz

uint8_t Prescale_Calculate(float frequency);
void PCA9685_Init(I2C_HandleTypeDef *hi2c, uint8_t DevAddress, float Frequency);
void PCA9685_SetChannelPWM(I2C_HandleTypeDef *hi2c, uint8_t DevAddress, uint8_t Channel, uint16_t On, uint16_t Off);
