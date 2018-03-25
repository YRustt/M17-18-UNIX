#include <unistd.h>
#include <sys/wait.h>

#define N 1000
#define M 100000000


int ar[M];

int main() {
    for (int i = 0; i < M; ++i) {
        ar[i] = i;
    }

    for (int i = 0; i < N; ++i) {
        pid_t pid = fork();
        if (pid) {
            int status;
            waitpid(pid, &status, 0);
        } else {
            execlp("/bin/true", "/bin/true", NULL, NULL);
        }
    }
    return 0;
}