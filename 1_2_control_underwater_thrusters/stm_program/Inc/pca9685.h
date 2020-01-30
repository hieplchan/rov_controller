#include <math.h>
#include "stm32f3xx_hal.h"

/*
 * In theory the internal oscillator (clock) is 25MHz but it really isn't that precise.
 * The int.osc. for the PCA9685 chip is a range between about 23-27MHz
 */
#define PCA9685_INTERNAL_FREQ       27000000
#define PCA9685_ADDRESS 						0x40<<1 	// I2C 7bit address need to left shift - HAL_Driver specs
#define PCA9685_REG_MODE1_ADDR 			0x00 			// Mode1 Register Address
#define PCA9685_REG_PRESCALE_ADDR		0xFE 			// PRE_SCALE Register Address - prescaler for PWM output frequency
#define PCA9685_REG_LED0_ON_L 			0x06
#define PCA9685_PRESCALE_MIN 				3   			// minimum prescale value
#define PCA9685_PRESCALE_MAX 				255 			// maximum prescale value

// MODE1
#define MODE1_ALLCAL 	0x01    // respond to LED All Call I2C-bus address
#define MODE1_SUB3 		0x02    // respond to I2C-bus subaddress 3
#define MODE1_SUB2 		0x04    // respond to I2C-bus subaddress 2
#define MODE1_SUB1 		0x08    // respond to I2C-bus subaddress 1
#define MODE1_SLEEP 	0x10    // Low power mode. Oscillator off
#define MODE1_AI 			0x20    // Auto-Increment enabled
#define MODE1_EXTCLK 	0x40    // Use EXTCLK pin clock
#define MODE1_RESTART 0x80    // Restart enabled
// MODE2
#define MODE2_OUTNE_0 0x01    // Active LOW output enable input */
#define MODE2_OUTNE_1 0x02    // Active LOW output enable input - high impedience */
#define MODE2_OUTDRV 	0x04    // totem pole structure vs open-drain */
#define MODE2_OCH 		0x08    // Outputs change on ACK vs STOP */
#define MODE2_INVRT 	0x10    // Output logic state inverted */

// ESC
#define ESC_FREQ 			50      // Output frequency, normal ESC ~ 50Hz

HAL_StatusTypeDef PCA9685_Reset(I2C_HandleTypeDef *hi2c);
HAL_StatusTypeDef PCA9685_Init(I2C_HandleTypeDef *hi2c);
HAL_StatusTypeDef PCA9685_Set_PWM_Freq(I2C_HandleTypeDef *hi2c, float Frequency);
HAL_StatusTypeDef PCA9685_Set_PWM(I2C_HandleTypeDef *hi2c, uint8_t Channel, uint16_t On, uint16_t Off);
