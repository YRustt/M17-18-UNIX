#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

#define MAX 100

pthread_mutex_t lock;

struct TContext {
    const char* Name;
    int* Counter;
    int Mod;
};

void* ThreadFunc(void* arg) {
    struct TContext* ctxt = arg;
    int* counter = ctxt->Counter;
    int flag = 1;
    fprintf(stderr, "This is %s thread\n", ctxt->Name);
    while (flag) {
        pthread_mutex_lock(&lock);
        if ((*counter < MAX) && (*counter % 2 == ctxt->Mod)) {
            printf("%d ", (*counter)++);
        }
        if (*counter == MAX) {
            flag = 0;
        }
        pthread_mutex_unlock(&lock);
    }
    pthread_exit(0);
}

int main()
{
    pthread_t t1;
    pthread_t t2;

    int counter = 0;
    struct TContext ctxt1 = {"even", &counter, 0};
    struct TContext ctxt2 = {"odd", &counter, 1};
    pthread_create(&t1, 0, ThreadFunc, &ctxt1);
    pthread_create(&t2, 0, ThreadFunc, &ctxt2);

    pthread_join(t1, 0);
    pthread_join(t2, 0);
    printf("\n");
    return 0;
}