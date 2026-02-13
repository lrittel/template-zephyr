#include <assert.h>
#include <stdbool.h>

#include <zephyr/drivers/gpio.h>
#include <zephyr/kernel.h>
#include <zephyr/logging/log.h>

#include "version.h"

static LOG_MODULE_REGISTER(main);

#define SLEEP_TIME_MS 900
#define LED0_NODE DT_ALIAS(led0)

static const struct gpio_dt_spec led = GPIO_DT_SPEC_GET(LED0_NODE, gpios);

int main(void) {
  int result;

  if (!device_is_ready(led.port)) {
    return -ENODEV;
  }

  LOG_INF("Application version: %s", APPLICATION_VERSION);

  result = gpio_pin_configure_dt(&led, GPIO_OUTPUT_ACTIVE);
  if (result < 0) {
    return result;
  }

  while (true) {
    result = gpio_pin_toggle_dt(&led);
    if (result < 0) {
      return result;
    }
    k_msleep(500);
  }
}
