#include <stdio.h>
#include <unistd.h>
#include <sys/mman.h>


int main() {
    size_t amount = 109951162777600LL;
    void* addr = mmap(0, amount, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE, -1, 0);
    if (addr == MAP_FAILED) {
        perror("map error");
        return 1;
    }

    char c;
    read(STDIN_FILENO, &c, 1);

    if (munmap(addr, amount) == -1) {
        perror("munmap error");
        return 1;
    }
    return 0;
}