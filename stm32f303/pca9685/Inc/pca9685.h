#include "stm32f3xx_hal.h"

#define PCA9685_ADDRESS 0x40
#define PCA9685_MODE1 0x00 // Mode Register 1
#define PCA9685_PRESCALE 0xFE // Prescaler for PWM output frequency

void PCA9685_Init(I2C_HandleTypeDef *hi2c, uint8_t address);
void PCA9685_PWM(I2C_HandleTypeDef *hi2c, uint8_t address, uint8_t num, uint16_t on, uint16_t off);
