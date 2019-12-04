#include "pca9685.h"

uint8_t Prescale_Calculate(float frequency)
{
  float prescaleval = 25000000/4096;
  uint8_t prescale = 3; // minimum value

  // Prescale calculate
  prescaleval /= frequency;
  prescaleval -= 1;
  prescale = floorf(prescaleval);
  return prescale;
}

void PCA9685_Init(I2C_HandleTypeDef *hi2c, uint8_t DevAddress, float Frequency)
{
  uint8_t oldmode, newmode;
  uint8_t prescale;

  // Put PCA9685 to Sleep mode
  HAL_I2C_Mem_Read(hi2c, DevAddress, PCA9685_REG_MODE1, 1, &oldmode, 1, 1);
  newmode = oldmode & 0x7F; // Clear restart bit
  newmode = newmode | 0x10; // Set sleep bit
  HAL_I2C_Mem_Write(hi2c, DevAddress, PCA9685_REG_MODE1, 1, &newmode, 1, 1);

  // Set PWM Frequency
  prescale = Prescale_Calculate(Frequency);
  HAL_I2C_Mem_Write(hi2c, DevAddress, PCA9685_REG_PRESCALE, 1, &prescale, 1, 1);
  HAL_Delay(10);

  // Put PCA to Normal mode
  newmode = (newmode & ~(0x10)) | 0xA0; // Clear sleep bit
  HAL_I2C_Mem_Write(hi2c, DevAddress, PCA9685_REG_PRESCALE, 1, &prescale, 1, 1);
}

void PCA9685_SetChannelPWM(I2C_HandleTypeDef *hi2c, uint8_t DevAddress, uint8_t Channel, uint16_t On, uint16_t Off)
{
  // LED0_ON_L REG address start from 0x06 - ON (LOW, HIGH) - OFF (LOW, HIGH) is 4 bytes
  uint8_t reg_on_low = PCA9685_REG_LED0_ON_L + Channel*4;
  uint8_t reg_on_high = PCA9685_REG_LED0_ON_L + Channel*4 + 1;
  uint8_t reg_off_low = PCA9685_REG_LED0_ON_L + Channel*4 + 2;
  uint8_t reg_off_high = PCA9685_REG_LED0_ON_L + Channel*4 + 3;

  uint8_t on_low = On & 0xFF;
  uint8_t on_high = (On >> 8) & 0xFF;
  uint8_t off_low =  Off & 0xFF;
  uint8_t off_high = (Off >> 8) & 0xFF;
  HAL_I2C_Mem_Write(hi2c, DevAddress, reg_on_low, 1, &on_low, 1, 1);
  HAL_I2C_Mem_Write(hi2c, DevAddress, reg_on_high, 1, &on_high, 1, 1);
  HAL_I2C_Mem_Write(hi2c, DevAddress, reg_off_low, 1, &off_low, 1, 1);
  HAL_I2C_Mem_Write(hi2c, DevAddress, reg_off_high, 1, &off_high, 1, 1);
}
