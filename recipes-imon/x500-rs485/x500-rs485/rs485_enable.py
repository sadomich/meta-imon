#!/usr/bin/env python3
import fcntl
import struct
import os
import sys

SER_RS485_ENABLED = 0x00000001
TIOCSRS485 = 0x542F


def set_rs485_mode(device):
    try:
        fd = os.open(device, os.O_RDWR | os.O_NOCTTY)
    except Exception as e:
        print(f"Failed to open {device}: {e}")
        return False

    flags = SER_RS485_ENABLED
    delay_before_send = 0
    delay_after_send = 0
    padding = (0, 0, 0, 0, 0, 0)  # 6 zeros to make total 9 unsigned ints

    fmt = '9I'
    data = struct.pack(fmt, flags, delay_before_send, delay_after_send, *padding)

    try:
        fcntl.ioctl(fd, TIOCSRS485, data)
        print(f"RS485 mode enabled on {device}")
    except Exception as e:
        print(f"ioctl failed on {device}: {e}")
        os.close(fd)
        return False

    os.close(fd)
    return True

if __name__ == '__main__':
    devices = ['/dev/ttyAMA0', '/dev/ttySC0']
    all_ok = True
    for dev in devices:
        if not set_rs485_mode(dev):
            all_ok = False

    sys.exit(0 if all_ok else 1)

