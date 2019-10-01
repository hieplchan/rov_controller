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

uint8_t PCA9685_SetChannelPWM(I2C_HandleTypeDef *hi2c, uint8_t DevAddress, uint8_t Channel, uint16_t On, uint16_t Off)
{
  // LED0_ON_L REG address start from 0x06 - ON (LOW, HIGH) - OFF (LOW, HIGH) is 4 bytes
  uint8_t buffer[5] = {0x06 + 4*Channel, On, (On >> 8), Off, (Off >> 8)};
  if (HAL_I2C_Master_Transmit(hi2c, DevAddress, buffer, 5, 1) == HAL_OK)
  {
    return 1;
  }
  else
  {
    return 0;
  }
}
