#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <unistd.h>
#include <semaphore.h>
#include <fcntl.h>
#include <errno.h>
#include <time.h>

// For shared memory
#include <sys/ipc.h>
#include <sys/shm.h>
#define SHM_SIZE 4096

typedef struct {
    int step;
    int process;
    char command[16];  // Changed to a string
    char command_exists;
} opcommand;

int main(int argc, char *argv[]) {
    if (argc != 4 || access(argv[1], F_OK) != 0 || access(argv[2], F_OK) != 0) {
        return -1;
    }

    for (int i = 0; i < strlen(argv[3]); i++) {
        if (!isdigit(argv[3][i])) {
            return -1;
        }
    }

    int num_of_max_active_processes = atoi(argv[3]);
    FILE *file1 = fopen(argv[1], "r");
    FILE *file2 = fopen(argv[2], "r");

    if (file1 == NULL || file2 == NULL) {
        return -1;
    }

    sem_t *semaphores[num_of_max_active_processes];
    char semaphore_names[num_of_max_active_processes][32];

    for (int i = 0; i < num_of_max_active_processes; i++) {
        snprintf(semaphore_names[i], sizeof(semaphore_names[i]), "/sem_%d", i);
        sem_unlink(semaphore_names[i]);
        semaphores[i] = sem_open(semaphore_names[i], O_CREAT | O_EXCL, 0666, 0);

        if (semaphores[i] == SEM_FAILED) {
            printf("Error creating semaphore\n");
            return -1;
        }
    }

    char line[256];
    char line1[256];
    int n = sizeof(line);
    int n1 = sizeof(line1);
    int step;
    char process[16], command[16];

    int active_processes[30];
    for (int i = 0; i < 30; i++) {
        active_processes[i] = 0;
    }

    int last_step = 0;
    int final_step = -1;
    int exit_step_found = 0;
    int configuration_file_line_count = 0;

    while (fgets(line1, n1, file2)) {
        configuration_file_line_count++;
    }

    rewind(file2);

    char configuration_file_content[configuration_file_line_count][256];
    for (int i = 0; i < configuration_file_line_count; i++) {
        fgets(line1, n1, file2);
        strcpy(configuration_file_content[i], line1);
    }

    int no_of_commands = 0;
    while (fgets(line, n, file1)) {
        no_of_commands++;
    }

    rewind(file1);

    opcommand commandsstruct[no_of_commands];
    for (int i = 0; i < no_of_commands; i++) {
        commandsstruct[i].process = 0;
        strncpy(commandsstruct[i].command, "", sizeof(commandsstruct[i].command));
        commandsstruct[i].command_exists = 'N';
    }

    while (fgets(line, n, file1)) {
        if (sscanf(line, "%d %s %s", &step, process, command) == 3) {
            if (last_step > step) {
                printf("Error, commands are not in ascending order\n");
                return -1;
            }

            if (process[0] != 'C') {
                printf("Error\n");
                return -1;
            }

            for (int i = 1; i < strlen(process); i++) {
                if (!isdigit(process[i])) {
                    printf("Error\n");
                    return -1;
                }
            }

            if (strcmp(command, "S") != 0 && strcmp(command, "T") != 0) {
                printf("Error\n");
                return -1;
            } else if (strcmp(command, "S") == 0) {
                if (active_processes[atoi(process + 1)] == 1) {
                    printf("Double Starting process %s\n", process);
                    return -1;
                } else {
                    active_processes[atoi(process + 1)] = 1;
                    commandsstruct[step].command_exists = 'Y';
                    commandsstruct[step].process = atoi(process + 1);
                    strncpy(commandsstruct[step].command, "S", sizeof(commandsstruct[step].command));
                }
            } else if (strcmp(command, "T") == 0) {
                if (active_processes[atoi(process + 1)] == 0) {
                    printf("Terminating unstarted process %s\n", process);
                    return -1;
                } else {
                    active_processes[atoi(process + 1)] = 0;
                    commandsstruct[step].command_exists = 'Y';
                    commandsstruct[step].process = atoi(process + 1);
                    strncpy(commandsstruct[step].command, "T", sizeof(commandsstruct[step].command));
                }
            }

            if (final_step < step && exit_step_found == 0) {
                final_step = step;
            }
        } else if (sscanf(line, "%d %s", &step, command) == 2) {
            if (last_step > step) {
                printf("Error, commands are not in ascending order\n");
                return -1;
            }

            if (strcmp(command, "EXIT") != 0) {
                printf("Error\n");
                return -1;
            } else if (exit_step_found == 0) {
                final_step = step;
                exit_step_found = 1;
                commandsstruct[step].command_exists = 'Y';
                commandsstruct[step].process = 0;
                strncpy(commandsstruct[step].command, "EXIT", sizeof(commandsstruct[step].command));
            }
        } else {
            printf("Error\n");
            return -1;
        }

        last_step = step;
    }

    int no_of_currently_running_processes = 0;
    pid_t parent_process_id = getpid();
    pid_t pid;

    key_t key = IPC_PRIVATE;
    int shmid = shmget(key, SHM_SIZE, IPC_CREAT | 0666);
    if (shmid < 0) {
        perror("shmget failed");
        exit(1);
    }

    char *shared_memory = (char *)shmat(shmid, NULL, 0);
    if (shared_memory == (char *)-1) {
        perror("shmat failed");
        exit(1);
    }

    strncpy(shared_memory, "HELLO WORLD", 256);

    for (int i = 0; i <= final_step; i++) {
        if (commandsstruct[i].command_exists == 'Y') {
            if (strcmp(commandsstruct[i].command, "S") == 0) {
                no_of_currently_running_processes++;
                if (no_of_currently_running_processes > num_of_max_active_processes) {
                    printf("Error, max active processes exceeded\n");
                    return -1;
                }

                if (getpid() == parent_process_id) {
                    pid = fork();
                }

                if (pid < 0) {
                    printf("Error\n");
                    return -1;
                } else if (pid == 0) {
                    break;
                }
            } else if (strcmp(commandsstruct[i].command, "T") == 0) {
                no_of_currently_running_processes--;
            }
        }
    }

    if (pid == 0) {
        srand(time(NULL) ^ getpid());
        int r = rand() % configuration_file_line_count;
        printf("%s\n", configuration_file_content[r]);
        exit(0);
    }

    for (int i = 0; i < num_of_max_active_processes; i++) {
        sem_unlink(semaphore_names[i]);
        sem_close(semaphores[i]);
    }
    printf("here\n");
    for(int i =0;i<configuration_file_line_count;i++){
        printf("%s", configuration_file_content[i]);
    }

    return 0;
}
