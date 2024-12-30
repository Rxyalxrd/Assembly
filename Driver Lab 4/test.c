#include <libusb-1.0/libusb.h>
#include <stdio.h>

void print_device(libusb_device *dev) {
    struct libusb_device_descriptor desc;
    int ret = libusb_get_device_descriptor(dev, &desc);
    if (ret < 0) {
        fprintf(stderr, "Ошибка при получении дескриптора устройства\n");
        return;
    }

    printf("Детали устройства:\n");
    printf("  Vendor ID: %04x\n", desc.idVendor);
    printf("  Product ID: %04x\n", desc.idProduct);
    printf("  Class: %02x\n", desc.bDeviceClass);
    printf("  Subclass: %02x\n", desc.bDeviceSubClass);
    printf("  Protocol: %02x\n", desc.bDeviceProtocol);
    printf("  Max Packet Size: %d\n", desc.bMaxPacketSize0);
    printf("  Number of Configurations: %d\n", desc.bNumConfigurations);
    printf("  USB Version: %x.%x\n", desc.bcdUSB >> 8, desc.bcdUSB & 0xFF);
    printf("\n");
}

int main() {
    libusb_device **list;
    libusb_context *ctx = NULL;
    ssize_t count;
    int ret;

    ret = libusb_init(&ctx);
    if (ret < 0) {
        fprintf(stderr, "Ошибка инициализации libusb: %d\n", ret);
        return 1;
    }

    count = libusb_get_device_list(ctx, &list);
    if (count < 0) {
        fprintf(stderr, "Ошибка получения списка устройств\n");
        libusb_exit(ctx);
        return 1;
    }

    printf("Найдено устройств: %ld\n", count);

    for (ssize_t i = 0; i < count; i++) {
        print_device(list[i]);
    }

    libusb_free_device_list(list, 1);
    libusb_exit(ctx);
    return 0;
}

// usbipd list
// usbipd bind -b 2-4
// usbipd attach -w --busid 2-4
// lsusb