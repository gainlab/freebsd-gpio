#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <sys/gpio.h>

MODULE = GPIO               PACKAGE = GPIO

SV*
_get_max_pin(fd)
    int fd;
INIT:
    int err, maxpin;
    maxpin = 0;
CODE:
    err = ioctl(fd, GPIOMAXPIN, &maxpin);
    if (err < 0) {
        croak("ioctl(GPIOMAXPIN) failed: %s\n", strerror(errno));
        RETVAL = &PL_sv_undef;
    }
    else
        RETVAL = newSViv(maxpin);
OUTPUT:
    RETVAL

SV*
_is_pin_valid(fd, pinno)
    int fd;
    int pinno;
INIT:
    int err;
    struct gpio_pin pin;
CODE:
    pin.gp_pin = pinno;
    err = ioctl(fd, GPIOGETCONFIG, &pin);
    if (err < 0)
        RETVAL = &PL_sv_no;
    else
        RETVAL = &PL_sv_yes;
OUTPUT:
    RETVAL

SV*
_get_pin_name(fd, pinno)
    int fd;
    int pinno;
INIT:
    int err;
    struct gpio_pin pin;
CODE:
    pin.gp_pin = pinno;
    err = ioctl(fd, GPIOGETCONFIG, &pin);
    if (err < 0) {
        croak("ioctl(GPIOGETCONFIG) failed: %s\n", strerror(errno));
        RETVAL = &PL_sv_undef;
    } else
        RETVAL = newSVpv(pin.gp_name, 0);
OUTPUT:
    RETVAL

SV*
_get_pin_caps(fd, pinno)
    int fd;
    int pinno;
INIT:
    int err;
    struct gpio_pin pin;
CODE:
    pin.gp_pin = pinno;
    err = ioctl(fd, GPIOGETCONFIG, &pin);
    if (err < 0) {
        croak("ioctl(GPIOGETCONFIG) failed: %s\n", strerror(errno));
        RETVAL = &PL_sv_undef;
    } else
        RETVAL = newSViv(pin.gp_caps);
OUTPUT:
    RETVAL

SV*
_get_pin_config(fd, pinno)
    int fd;
    int pinno;
INIT:
    int err;
    struct gpio_pin pin;
CODE:
    pin.gp_pin = pinno;
    err = ioctl(fd, GPIOGETCONFIG, &pin);
    if (err < 0) {
        croak("ioctl(GPIOGETCONFIG) failed: %s\n", strerror(errno));
        RETVAL = &PL_sv_undef;
    } else
        RETVAL = newSViv(pin.gp_flags);
OUTPUT:
    RETVAL

SV*
_set_pin_config(fd, pinno, config)
    int fd;
    int pinno;
    int config;
INIT:
    int err;
    struct gpio_pin pin;
CODE:
    pin.gp_pin = pinno;
    pin.gp_flags = config;
    err = ioctl(fd, GPIOSETCONFIG, &pin);
    if (err < 0) {
        croak("ioctl(GPIOSETCONFIG) failed: %s\n", strerror(errno));
        RETVAL = &PL_sv_no;
    } else
        RETVAL = &PL_sv_yes;
OUTPUT:
    RETVAL

SV*
_get_pin_value(fd, pinno)
    int fd;
    int pinno;
INIT:
    int err;
    struct gpio_req req;
CODE:
    req.gp_pin = pinno;
    err = ioctl(fd, GPIOGET, &req);
    if (err < 0) {
        croak("ioctl(GPIOGET) failed: %s\n", strerror(errno));
        RETVAL = &PL_sv_undef;
    } else
        RETVAL = newSViv(req.gp_value);
OUTPUT:
    RETVAL

SV*
_set_pin_value(fd, pinno, value)
    int fd;
    int pinno;
    int value;
INIT:
    int err;
    struct gpio_req req;
CODE:
    req.gp_pin = pinno;
    req.gp_value = value ? 1 : 0;
    err = ioctl(fd, GPIOSET, &req);
    if (err < 0) {
        croak("ioctl(GPIOSET) failed: %s\n", strerror(errno));
        RETVAL = &PL_sv_no;
    } else
        RETVAL = &PL_sv_yes;
OUTPUT:
    RETVAL

SV*
_toggle_pin_value(fd, pinno)
    int fd;
    int pinno;
    int value;
INIT:
    int err;
    struct gpio_req req;
CODE:
    req.gp_pin = pinno;
    err = ioctl(fd, GPIOTOGGLE, &req);
    if (err < 0) {
        croak("ioctl(GPIOTOGGLE) failed: %s\n", strerror(errno));
        RETVAL = &PL_sv_undef;
    } else
        RETVAL = &PL_sv_yes;
OUTPUT:
    RETVAL