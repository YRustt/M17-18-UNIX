#include <stdio.h>
#include <stdbool.h>
#include <unistd.h>
#include <pthread.h>

void *my_thread_function(void *args) {
    const char *c=(const char *)args;
    while (true) {
        printf("%s", c);
//        write(STDOUT_FILENO, c, 1);
    }
    return NULL;
}


int main() {
    pthread_t tid_1, tid_2;

    pthread_create(&tid_1, NULL, my_thread_function, (void *)"a");
    pthread_create(&tid_2, NULL, my_thread_function, (void *)"b");
    sleep(1);

    return 0;
}