#include "stm32f3xx_hal.h"

#define PCA9685_ADDRESS 0x80
#define PCA9685_REG_MODE1 0x00 // Mode1 Register Address
#define PCA9685_REG_PRESCALE 0xFE // PRE_SCALE Register Address - prescaler for PWM output frequency
#define PCA9685_FREQUENCY 50 // Frequency of entire chip, 24 Hz to 1526 Hz

HAL_StatusTypeDef PCA9685_I2C_Test(I2C_HandleTypeDef *hi2c, uint8_t address);
void PCA9685_Init(I2C_HandleTypeDef *hi2c, uint8_t address);
void PCA9685_Reset(I2C_HandleTypeDef *hi2c, uint8_t address);
void PCA9685_SetPWMFrequency(I2C_HandleTypeDef *hi2c, uint8_t address, float frequency);
void PCA9685_SetChannelPWM(I2C_HandleTypeDef *hi2c, uint8_t address, uint8_t channel, uint16_t on, uint16_t off);
