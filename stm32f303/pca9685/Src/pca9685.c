#include "pca9685.h"

void PCA9685_Init(I2C_HandleTypeDef *hi2c, uint8_t address)
{
  uint8_t initStruct[2];
  HAL_I2C_Master_Transmit(hi2c, address, PCA9685_MODE1, 1, 1);
  uint8_t oldmode = 0;
  uint8_t newmode = ((oldmode & 0x7F) | 0x10); // sleep
  initStruct[0] = PCA9685_MODE1;
  initStruct[1] = newmode; // go to sleep, turn off internal oscillator

  // This sets both the SLEEP and EXTCLK bits of the MODE1 register to switch to
  // use the external clock
  HAL_I2C_Master_Transmit(hi2c, address, initStruct, 2, 1);

  // set the prescaler
  initStruct[1] = PCA9685_PRESCALE;
  HAL_I2C_Master_Transmit(hi2c, address, initStruct, 2, 1);

  initStruct[1] = oldmode;
  HAL_I2C_Master_Transmit(hi2c, address, initStruct, 2, 1);

  HAL_Delay(5);

  // clear the SLEEP bit to start
  initStruct[1] = (oldmode | 0xA1);
  HAL_I2C_Master_Transmit(hi2c, address, initStruct, 2, 1);
}

void PCA9685_Reset(I2C_HandleTypeDef *hi2c, uint8_t address)
{

}

/*!
 *  @brief  Sets the PWM frequency for the entire chip, up to ~1.6 KHz
 *  @param  freq Floating point frequency that we will attempt to match
 */
void PCA9685_SetPWMFrequency(I2C_HandleTypeDef *hi2c, uint8_t address, float frequency)
{
  float prescaleval = 25000000;
  prescaleval /= 4096;
  prescaleval /= frequency;
  prescaleval -= 1;
}

void PCA9685_SetChannelPWM(I2C_HandleTypeDef *hi2c, uint8_t address, uint8_t channel, uint16_t on, uint16_t off)
{
 uint8_t outputBuffer[5] = {0x06 + 4*channel, on, (on >> 8), off, (off >> 8)};
 HAL_I2C_Master_Transmit(hi2c, address, outputBuffer, 5, 1);
}
