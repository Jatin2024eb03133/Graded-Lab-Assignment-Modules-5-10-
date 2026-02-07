#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <sys/types.h>

volatile sig_atomic_t got_sigterm = 0;
volatile sig_atomic_t got_sigint  = 0;

void handle_sigterm(int sig) {
    (void)sig;
    got_sigterm = 1;
}

void handle_sigint(int sig) {
    (void)sig;
    got_sigint = 1;
}

int main(void) {
    pid_t parent_pid = getpid();

    // Set signal handlers (parent process)
    if (signal(SIGTERM, handle_sigterm) == SIG_ERR) {
        perror("signal(SIGTERM)");
        return 1;
    }
    if (signal(SIGINT, handle_sigint) == SIG_ERR) {
        perror("signal(SIGINT)");
        return 1;
    }

    printf("Parent PID: %d\n", parent_pid);
    printf("Parent running indefinitely... waiting for signals.\n");

    // Child 1: send SIGTERM after 5 seconds
    pid_t c1 = fork();
    if (c1 < 0) {
        perror("fork child1");
        return 1;
    }
    if (c1 == 0) {
        sleep(5);
        printf("Child1 (%d) sending SIGTERM to parent (%d)\n", getpid(), parent_pid);
        kill(parent_pid, SIGTERM);
        _exit(0);
    }

    // Child 2: send SIGINT after 10 seconds
    pid_t c2 = fork();
    if (c2 < 0) {
        perror("fork child2");
        return 1;
    }
    if (c2 == 0) {
        sleep(10);
        printf("Child2 (%d) sending SIGINT to parent (%d)\n", getpid(), parent_pid);
        kill(parent_pid, SIGINT);
        _exit(0);
    }

    // Parent loop (runs indefinitely until a signal triggers exit)
    while (1) {
        pause(); // wait for a signal

        if (got_sigterm) {
            printf("Parent received SIGTERM. Handling it differently (graceful shutdown).\n");
            printf("Exiting now due to SIGTERM.\n");
            break;
        }

        if (got_sigint) {
            printf("Parent received SIGINT. Handling it differently (cleanup message).\n");
            printf("Exiting now due to SIGINT.\n");
            break;
        }
    }

    return 0;
}
