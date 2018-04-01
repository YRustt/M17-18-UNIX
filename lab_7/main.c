#include <stdio.h>
#include <unistd.h>
#include <sys/mman.h>


int main() {
    size_t amount = 109951162777600LL;
    void* addr = mmap(0, amount, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE, -1, 0);

    char c;
    read(STDIN_FILENO, &c, 1);

    munmap(addr, amount);
    return 0;
}