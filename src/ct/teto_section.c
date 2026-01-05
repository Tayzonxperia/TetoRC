#include <stdint.h>

__attribute__((section(".teto"), used)) // Custom section to embed stuff :3
struct teto_section {
    char magic_str[4];
    uint8_t magic_num; 
    uint8_t ver_major;
    uint8_t ver_mid;
    uint8_t ver_minor;
    char rel_tag[6];
    uint8_t reserved[4];
}   teto_section = {
        .magic_str = {'T','E','T','O'},
        .magic_num = 0x04,
        .ver_major = 1,
        .ver_mid = 4,
        .ver_minor = 2,
        .rel_tag = {'a','l','p','h','a','4'},
        .reserved = {0},
    };