/**
  ******************************************************************************
  * @file    main.c
  * @author  hiep.lchan@gmail.com
	* @date    19-June-2019
  * @brief   ROV Controller using STM32F3DISCOVERY
  *          This file main file to run Controller.
*/

#include "main.h"

GPIO_InitTypeDef        GPIO_InitStructure;

void LED_Init(void);
void Delay(uint32_t delay);

int main(void)
{
  LED_Init();

  while (1)
  {
    /* Set PE15 */
    GPIO_SetBits(GPIOE, GPIO_Pin_15);
    Delay(5000);

    /* Reset PE15 */
    GPIO_ResetBits(GPIOE, GPIO_Pin_15);
    Delay(5000);
  }
}

void LED_Init(void)
{
  /* GPIOE Periph clock enable */
  RCC_AHBPeriphClockCmd(RCC_AHBPeriph_GPIOE, ENABLE);

  /* Configure PE15 in output pushpull mode */
  GPIO_InitStructure.GPIO_Pin = GPIO_Pin_15;
  GPIO_InitStructure.GPIO_Mode = GPIO_Mode_OUT;
  GPIO_InitStructure.GPIO_OType = GPIO_OType_PP;
  GPIO_InitStructure.GPIO_Speed = GPIO_Speed_2MHz;
  GPIO_InitStructure.GPIO_PuPd = GPIO_PuPd_NOPULL;
  GPIO_Init(GPIOE, &GPIO_InitStructure);
}

/**
  * @brief  Inserts a delay time.
  * @param  delay: specifies the delay time length
  * @retval None
  */
void Delay(uint32_t delay)
{
	while (delay--);
}

#ifdef  USE_FULL_ASSERT

/**
  * @brief  Reports the name of the source file and the source line number
  *         where the assert_param error has occurred.
  * @param  file: pointer to the source file name
  * @param  line: assert_param error line source number
  * @retval None
  */
void assert_failed(uint8_t* file, uint32_t line)
{
  /* User can add his own implementation to report the file name and line number,
     ex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */

  /* Infinite loop */
  while (1)
  {
  }
}
#endif
