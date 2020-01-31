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

/* MODE1 */
#define PCA9685_MODE1_SLEEP 	0x10    // Low power mode. Oscillator off
#define PCA9685_MODE1_AI 			0x20    // Auto-Increment enabled
#define PCA9685_MODE1_RESTART 0x80    // Restart enabled

/* SERVO MOTOR ESC */
#define SERVO_FREQ          50    // Output frequency, normal ESC ~ 50Hz
#define SERVO_MSMIN         1     // rounded 'minimum' millisecond length
#define SERVO_MSMAX         2     // rounded 'maximum' millisecond length
#define SERVO_PULSE_MIN     205   // 'minimum' pulse length count SERVO_MSMIN/(1000 (ms)/SERVO_FREQ/4096 (pulse resolution))
#define SERVO_PULSE_MAX     410   // 'maximum' pulse length count SERVO_MSMAX/(1000 (ms)/SERVO_FREQ/4096 (pulse resolution))
#define SERVO_PULSE_NEUTRAL 308   // 'maximum' pulse length count SERVO_MSMAX/(1000 (ms)/SERVO_FREQ/4096 (pulse resolution))
#define SERVO_THROTTLE_MIN  -100  // 'minimum' throttle -100% (reverse)
#define SERVO_THROTTLE_MAX  100   // 'maximum' throttle 100% (forward)

/* PCA9685 functions  ************************************************/
HAL_StatusTypeDef PCA9685_Reset(I2C_HandleTypeDef *hi2c);
HAL_StatusTypeDef PCA9685_Init(I2C_HandleTypeDef *hi2c);
HAL_StatusTypeDef PCA9685_Set_PWM_Freq(I2C_HandleTypeDef *hi2c, float Frequency);
HAL_StatusTypeDef PCA9685_Set_PWM(I2C_HandleTypeDef *hi2c, uint8_t Channel, uint16_t On, uint16_t Off);

/* Servo ESC Control functions  **************************************/
HAL_StatusTypeDef Servo_Set_Throttle(I2C_HandleTypeDef *hi2c, uint8_t Channel, int8_t throttle);
