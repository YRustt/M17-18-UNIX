#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>
#include <time.h>

#define N 1000
#define M 100000000


//int ar[M];

int main() {
//    for (int i = 0; i < M; ++i) {
//        ar[i] = i;
//    }

    clock_t start_time = clock();
    for (int i = 0; i < N; ++i) {
        pid_t pid = fork();
        if (pid) {
            int status;
            waitpid(pid, &status, 0);
        } else {
            execlp("/bin/true", "/bin/true", NULL, NULL);
        }
    }
    clock_t end_time = clock();
    printf("%f\n", (float)(end_time - start_time) / CLOCKS_PER_SEC);
    return 0;
}