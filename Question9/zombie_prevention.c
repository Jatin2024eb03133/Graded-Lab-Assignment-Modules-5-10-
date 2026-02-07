#include <stdio.h>
#include <stdlib.h>
#include <process.h>
#include <windows.h>

int main() {
    for (int i = 0; i < 3; i++) {
        int pid = _spawnl(_P_NOWAIT, "cmd.exe", "cmd.exe", "/c", "exit", NULL);

        if (pid == -1) {
            perror("spawn failed");
            exit(1);
        }

        printf("Created child process PID: %d\n", pid);
        WaitForSingleObject((HANDLE)pid, INFINITE);
        printf("Cleaned up child PID: %d\n", pid);
    }

    return 0;
}

