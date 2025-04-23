#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <unistd.h>
#include <semaphore.h>
#include <fcntl.h>
#include <errno.h>
#include <time.h>
// for shared memory
#include <sys/shm.h>
#include <sys/stat.h>
#include <stdbool.h>
#include <sys/mman.h>
#include <unistd.h>
#include <sys/wait.h>


#define MAX_CHILDREN 100
unsigned int seed;


typedef struct
{
    int pid;
    int name;
} runningprocess; //struct to identify each running process
typedef struct
{
    int step; //no of step to be executed
    int process; //number of C(number) process that the command is refering to
    char command[2]; //type of command from config file, "S" or "T", if it exists
    char command_exists[2]; //unless value is "Y", the step executes without a command from the config file
} opcommand; //struct to store each step for the parent process to execute (if a command exists)

void child_process(sem_t *, sem_t *, void *, void *,void* ,int ,int*);
int choose_random_active_child(opcommand *, int, int,int);

int main(int argc, char *argv[])
{
    if (argc != 4 || access(argv[1], F_OK) != 0 || access(argv[2], F_OK) != 0)
    {
        return -1;
    } //check if the number of arguments to execute the process is correct

    for (int i = 0; i < strlen(argv[3]); i++)
    {
        if (!isdigit(argv[3][i]))
        {
            return -1;
        }
    } //check if the parameter for the number of max active processes is a number
    int num_of_max_active_processes = atoi(argv[3]);
    FILE *file1 = fopen(argv[1], "r"); //open config file
    FILE *file2 = fopen(argv[2], "r"); //open text file
    if (file1 == NULL || file2 == NULL)
    {
        return -1;
    } //if either doesn't exist, return error
    sem_t *semaphores[num_of_max_active_processes]; //create array of semaphores for the child processes with a length equal to the inputted max active processes 
    char semaphore_names[num_of_max_active_processes][32]; 
    for (int i = 0; i < num_of_max_active_processes; i++)
    {

        snprintf(semaphore_names[i], sizeof(semaphore_names[i]), "/sem2_%d", i); //import the names of the semaphores on the semaphore_names table
        sem_close(semaphores[i]);   //close all semaphores in case they weren't closed from a previous program execution
        sem_unlink(semaphore_names[i]); //unlink the semaphore names to be used in case they weren't unlink at a previous execution 
        semaphores[i] = sem_open(semaphore_names[i], O_CREAT | O_EXCL, 0666, 0); //open the semaphores with error checking if it already exists with read/write permission in both user and group
        if (semaphores[i] == SEM_FAILED)
        {
            printf("Error creating semaphore");
            return -1;
        }
    }
    sem_unlink("/par_sem");
    sem_t *par_sem = sem_open("/par_sem", O_CREAT | O_EXCL, 0666, 0); //open semaphore for the parent process
    if (par_sem == SEM_FAILED)
    {
        return EXIT_FAILURE;
    }
    char line[257];
    char line1[257];
    int n = sizeof(line);
    int n1 = sizeof(line1);
    int step;
    char process[16], command[10];

    int last_step = 0;
    int final_step = -1; // step for the exit command
    int exit_step_found = 0;
    int text_file_line_count = 0;
    while (fgets(line1, n1, file2))
    {
        if (line1)
        {
            text_file_line_count++; //count the number of lines in the text file
        }
    }
    rewind(file2);
    char text_file_content[text_file_line_count][257];
    for (int i = 0; i < text_file_line_count; i++)
    {
        memset(line1, 0, sizeof(line1));
        if (fgets(line1, n1, file2))
        {
            // line1[strcspn(line1, "\n")] = '\0'; // Remove newline safely

            strncpy(text_file_content[i], line1, sizeof(line1)); //load all the lines from the text into a table
            if (i < text_file_line_count - 1)
            {
                text_file_content[i][strlen(line1) - 1] = '\0';
            }
        }
        else
        {
            printf("Error reading line %d from file2\n", i + 1);
            return -1; // Handle unexpected EOF or read error
        }
    }

    int no_of_commands = 0;
    while (fgets(line, n, file1))
    {
        no_of_commands++; //count the number of commands from the config file
    }
    rewind(file1); // return to start of file1
    int last_number = 0;
    char line2[100];
    while (fgets(line, sizeof(line), file1))
    {
        int number;
        char col[3], status[2];

        // Use sscanf to extract the number, column, and status
        int num = sscanf(line, "%d %s %s", &number, col, status);
        if (num == 3 || num == 2)
        {
            last_number = number; // Store the number in the 1st column -find the number of the final step
        }
    }

    rewind(file1);
    opcommand commandsstruct[last_number];
    for (int i = 0; i < last_number; i++)
    {
        commandsstruct[i].process = 0;
        strcpy(commandsstruct[i].command, " ");
        strcpy(commandsstruct[i].command_exists, "N"); //initialize struct for commands
    }

    while (fgets(line, n, file1))
    {
        if (sscanf(line, "%d %s %s", &step, process, command) == 3) //check if config file is correct
        {

            if (last_step > step)
            {
                printf("Error, commands are not in ascending order\n"); //check if the commands are in ascending step order
                return -1;
            }
            if (process[0] != 'C')
            {
                printf("Error character\n"); //check if process number has the format C(number)
                return -1;
            }

            for (int i = 1; i < strlen(process); i++)
            {
                if (!isdigit(process[i]))
                {
                    printf("Error not digit\n"); //check if process number has the format C(number)
                    return -1;
                }
            }

            if (strcmp(command, "S") != 0 && strcmp(command, "T") != 0)
            {
                printf("Error isnt S or T\n"); // check if the command is either S or T
                return -1;
            }
            //if all is ok, store the commands and process numbers on a table on its respective step number
            else if (strcmp(command, "S") == 0) 
            {

                commandsstruct[step].process = atoi(process + 1);
                strcpy(commandsstruct[step].command_exists, "Y");
                strcpy(commandsstruct[step].command, "S");
            }
            else if (strcmp(command, "T") == 0)
            {
                commandsstruct[step].process = atoi(process + 1);
                strcpy(commandsstruct[step].command_exists, "Y");
                strcpy(commandsstruct[step].command, "T");
            }
            if (final_step < step && exit_step_found == 0)
            {
                final_step = step; //set the current command as the final step for each loop
            }
        }
        else if (sscanf(line, "%d %s", &step, command) == 2) //if command without a process number is found, it is assumed to be the exit command
        {
            if (last_step > step)  
            {
                printf("Error, commands are not in ascending order\n");
                return -1;
            }
            if (strcmp(command, "EXIT") != 0)
            {
                printf("Error double exit\n");
                return -1;
            }
            else if (exit_step_found == 0)
            {
                final_step = step;  //if the exit command is found, set its step as the final step
                exit_step_found = 1; 
                commandsstruct[step].process = 0;
                strcpy(commandsstruct[step].command_exists, "Y");
                strcpy(commandsstruct[step].command, "E");
            }
        }
        else
        {
            printf("Error command in config file in wrong format\n");
            return -1;
        }
        last_step = step;
    }
    int no_of_currently_running_processes = 0;
    pid_t parent_process_id = getpid(); //get the parent process PID
    pid_t pid;
    srand(time(NULL) ^ getpid()); //initialize random number generation to pick lines from the text
    const int SIZE = 4096;
    char *shared_memory_name = "OS11";
    char message0[256];
    long int pid_semaphore[num_of_max_active_processes];
    for (int i = 0; i < num_of_max_active_processes; i++)
    {
        pid_semaphore[i] = 0; //initialize a table to store the pid of each possible active process to identify which semaphore is used by which PID
    }

    int shm_fd;
    int child_count = 0;
    runningprocess child_pid_name[MAX_CHILDREN];
    void *ptr;
    shm_unlink(shared_memory_name); // unlink shared memory name

    close(shm_fd); // close shared memory
    shm_fd = shm_open(shared_memory_name, O_CREAT | O_RDWR, 0666); //initialize shared memory
    if (ftruncate(shm_fd, SIZE) == -1) //configure the size of shared-memory region and check if the operation was successful
    {
        return -1;
    }

    void *originalptr = mmap(0, SIZE, PROT_WRITE | PROT_READ, MAP_SHARED, shm_fd, 0); //set originalptr as the starting pointer of the shared memory
    memset(originalptr, 0, SIZE); //initialize all shared memory with zeroes to prevent errors
    void *ptr_pid_semaphores = originalptr + 256; //set the memory pointer to store the pid_semaphore table
    void *original_ptr_pid_semaphores = ptr_pid_semaphores;
    long int *array = (long int *)originalptr + 256;
    for (int i = 0; i < num_of_max_active_processes; i++)
    {
        array[i] = 0;
        memcpy(ptr_pid_semaphores, &array[i], sizeof(array[i])); //fill the shared memory space for the pid table with long int zeroes
        ptr_pid_semaphores = ptr_pid_semaphores + sizeof(array[i]); //
    }
    void *ptr_command = ptr_pid_semaphores + sizeof(array[0]); // calculate the pointer position after the pid table to set a pointer to parent-child commands
    void *ptr_terminate_step = ptr_command + sizeof(int); 
    // int non_zero_indices[num_of_max_active_processes];
    // for (int i = 0; i < num_of_max_active_processes; i++)
    // {
    //     non_zero_indices[i] = 0;
    // } // measure number of active processes
    //int non_zero_count = 0;
    int child_messages=0;
    int starting_step = 0;
    int track_of_step;
    for (int i = 0; i <= final_step; i++)
    {
        track_of_step = i;
        
        int terminate_pid = 0; 
        

        if (strcmp(commandsstruct[i].command_exists, "Y") == 0)
        {
            if (strcmp(commandsstruct[i].command, "S") == 0)
            {
                no_of_currently_running_processes++;
                if (no_of_currently_running_processes > num_of_max_active_processes) //check if the programm attempts to simultaneously run more children processes than the defined limit
                {
                    printf("Error, max active processes exceeded\n");
                    return -1;
                }
                if (getpid() == parent_process_id)
                {
                    pid = fork(); //start a child process
                }
                if (pid < 0)
                {
                    printf("Error");
                    return -1;
                }
                else if (pid == 0) // Child process code
                {
                    starting_step = i;
                    int my_index;
                    long int *array = (long int *)original_ptr_pid_semaphores;
                    void *ptr2 = original_ptr_pid_semaphores;
                    for (int i = 0; i < num_of_max_active_processes; i++)
                    {
                        if (array[i] == 0) //find an empty spot on the table of the shared memory storing the pids linked to a semaphore
                        {
                            printf("Child %d has chosen semaphore %d\n", getpid(), i);
                            array[i] = getpid(); // Store the PID of the child process
                            my_index = i;
                            memcpy(ptr2, &array[i], sizeof(array[i])); // Store the PID in shared memory to know which semaphore to use with that PID
                            break;
                        }
                        else
                        {
                            ptr2 = ptr2 + sizeof(array[i]);
                        }
                    }
                    printf("Child %d that has semaphore %d will wake parent\n", getpid(), my_index);
                    sem_post(par_sem); // Notify parent process
                    child_process(semaphores[my_index], par_sem, originalptr, ptr_command,ptr_terminate_step,starting_step,&child_messages); //call the function for the child process
                    exit(0);
                }
                else // Parent process after forking
                {
                    child_pid_name[child_count].pid = pid;
                    child_pid_name[child_count++].name = commandsstruct[i].process; // Store the child PID
                    sem_wait(par_sem);                                              // Wait for the child to complete process before continuing
                }
            }
            else if (strcmp(commandsstruct[i].command, "T") == 0) //terminate command handling
            {
                printf("~~~~~~~~~~~~~~~~~~\n");
                printf("Step is %d and terminate command has been called---\n", i);
                printf("~~~~~~~~~~~~~~~~~~\n");

                int active_process_found = 0; //check if the process is indeed started so it can be termniated
                for (int j = 0; j < child_count; j++)
                {
                    
                    
                    if (child_pid_name[j].name == commandsstruct[i].process && child_pid_name[j].pid != 0)
                    {
                        terminate_pid = child_pid_name[j].pid; //if the PID is found, it is passed as a terminate command on the shared memory
                        child_pid_name[j].name = 0; //remove process data from the table storing the active child processes
                        child_pid_name[j].pid = 0;
                        active_process_found = 1;
                    }

                }
                if (active_process_found ==0){ //check if a terminate command was given to a process that hasn't started
                    printf("command to terminate process without it starting, ignoring\n");
                    continue;
                }
                no_of_currently_running_processes--;
                memcpy(ptr_command, &terminate_pid, sizeof(terminate_pid)); //copy the terminate command to the shared memory
                int new;
                // memcpy(&new, ptr_command, sizeof(int));
                // printf("ptr command is %d\n",new);
                memcpy(ptr_terminate_step, &i, sizeof(i)); //copy the current step number to the shared memory so the number of steps where the process was active can be printed
                
                int I = i;

                void *ptr4 = original_ptr_pid_semaphores;

                long int *array = (long int *)original_ptr_pid_semaphores;
                for (int i = 0; i < num_of_max_active_processes; i++)
                {

                    if (array[i] == terminate_pid)
                    {
                        printf("Child %d has left\n", terminate_pid);
                        array[i] = 0; // Store the PID in shared memory

                        memcpy(ptr4, &array[i], sizeof(array[i])); //remove PID from semaphore table in shared memory

                        // non_zero_count--;
                        // non_zero_indices[i] = 0;
                        printf("waking up terminate pid %d\n",terminate_pid);
                        sem_post(semaphores[i]); //activate the child process
                        sem_wait(par_sem);       //have the parent wait until the child completes
                        break;
                    }
                    else
                    {
                        ptr4 = ptr4 + sizeof(array[i]);
                    }
                }
            }
            else
            { // exit terminate all

                break;
            }
        }
        // print("no_of_currently_running_processes %d\n",)
        if (no_of_currently_running_processes > 0)
        {
            memcpy(&pid_semaphore, original_ptr_pid_semaphores, sizeof(pid_semaphore));
            // int chosen_index;
            int chosen_index = choose_random_active_child(commandsstruct, final_step, i,num_of_max_active_processes); //choose a random child to print a random line
            printf("~~~~~~~~~~~~~~~~~~\n");
            //printf("From parent %d Step is %d and child that has been picked is %d\n",getpid() ,i, chosen_index);
            
            int pid_chosen;
            for (int j = 0; j < child_count; j++)
            {
                if (child_pid_name[j].name == chosen_index)
                {
                    pid_chosen = child_pid_name[j].pid;
                }
            }
            for (int i = 0; i < num_of_max_active_processes; i++)
            {
                if (pid_semaphore[i] == pid_chosen)
                {
                    chosen_index = i;
                    break;
                }
            }
            printf("From parent %d Step is %d and child that has been picked is %ld\n",getpid() ,i, pid_semaphore[chosen_index]);
            printf("~~~~~~~~~~~~~~~~~~\n");
            int chosen_pid = pid_semaphore[chosen_index];
            //srand(time(NULL) ^ getpid());
            int r = rand() % text_file_line_count;
            printf("XXXXXXXXXXXXXXXXXXX\n");
            printf("Step %d Randomly chosen PID: %d at index: %d and random line: %d\n", i, chosen_pid, chosen_index, r);
            printf("XXXXXXXXXXXXXXXXXXX\n");
            printf("Randomly line in parent is %s\n", text_file_content[r]);
            strncpy(originalptr, text_file_content[r], 256); // First 256 bytes of shared memory
            // Notify the selected child process
            sem_post(semaphores[chosen_index]);
            // Wait for the child to complete the task
            sem_wait(par_sem);
        }
    }
    // exit terminate all command
    int terminate_pid = -1;
    memcpy(ptr_command, &terminate_pid, sizeof(terminate_pid));
    memcpy(ptr_terminate_step, &track_of_step,sizeof(track_of_step));
    for (int i = 0; i < num_of_max_active_processes; i++)
    {
        
        sem_post(semaphores[i]); //activate all blocked child processes to terminate
    }
    // for (int i = 0; i < child_count; i++)
    // {

    // }
    for (int i = 0; i < num_of_max_active_processes; i++)
    {
        //unlink semaphore names to avoid errors in future execution of the program when trying to open the same name
        //normally done at the end of the program but if it terminated abruptly the names remain linked
        sem_close(semaphores[i]);   
        sem_unlink(semaphore_names[i]);         //| O_EXCL βγαζει σφαλμα αν υπαρχει ηδη
        shm_unlink(shared_memory_name);      // unlink shared memory name
        if (munmap(originalptr, SIZE) == -1) // unmap shared memory pointer
        {
            perror("Failed to unmap shared memory");
        }
        close(shm_fd); // close shared memory
    }
    sem_close(par_sem); //close parent semaphore
    sem_unlink("/par_sem");
    for (int i = 0; i < child_count; i++)
    {
        if (child_pid_name[i].pid != 0)
        {
            waitpid(child_pid_name[i].pid, NULL, 0); // Wait for each child process to terminate
            child_pid_name[i].name = 0;
            child_pid_name[i].pid = 0;
        }
    } 
    if (fclose(file1) == EOF) {
       perror("Error closing file1");
       return 1;
   }
   if (fclose(file2) == EOF) {
       perror("Error closing file2");
       return 1;
   }
   exit(0);
    return 0;
}

void child_process(sem_t *child_sem, sem_t *par_sem, void *originalptr, void *ptr_command,void *ptr_terminate_step,int starting_step,int* child_messages)
{
    // Main loop: process commands
    while (1)
    {
        sem_wait(child_sem); // Wait for parent signal
        int terminatecommand;
        int terminate_step = -1;
        memcpy(&terminatecommand, ptr_command, sizeof(int));//open terminate command
        memcpy(&terminate_step, ptr_terminate_step, sizeof(int));

        if (terminatecommand != getpid() && terminatecommand != -1 ) //if the terminate command doesn't contain the PID of the child
        {
            int number = 0, chosen_child = 0;
            char message0[256];
            strncpy(message0, originalptr, 256); //get the random text line from shared memory
            (*child_messages)++;
            printf(" Message is '%s' and child %d \n", message0,getpid()); //print the text line
            printf("\n Child %d entering loop again\n", getpid());
            sem_post(par_sem); //unblock the parent
        }
        else
        {
            printf("Terminate command received is %d and step %d\n", terminatecommand,terminate_step);
            if (terminatecommand != -1 ){ 
                int terminate_pid = 0; //always reset the terminate command to zero after a process is terminated, unless the terminate command is for all processes
                memcpy(ptr_command, &terminate_pid, sizeof(terminate_pid));
            }            
            printf("Child %d leaving and no of messages that it has received are %d and number of steps %d\n", getpid(),*child_messages,terminate_step-starting_step);
            sem_post(par_sem);
            exit(0);
        }
    }
}


int choose_random_active_child(opcommand *commands, int max_step, int query_step,int M) //function to choose an active random child to print a line
{
    if (query_step > max_step) //check if function is called after the step the main process terminates
    {
        printf("Query step %d exceeds maximum step %d.\n", query_step, max_step);
        return -1;
    }

    bool active[MAX_CHILDREN] = {0};

    for (int i = 0; i <= query_step; i++) //check which process should be active on the current step based on the config file
    {
        int process = commands[i].process;
        if (strcmp(commands[i].command, "S") == 0)
        {
            active[process] = true;
        }
        else if (strcmp(commands[i].command, "T") == 0)
        {
            active[process] = false;
        }
    }


    int active_children[MAX_CHILDREN];
    int count = 0;
    for (int i = 0; i < MAX_CHILDREN; i++) //make a table which identifies which child is active
    {
        if (active[i])
        {
            active_children[count++] = i;
        }
    }

    if (count == 0)
    {
        printf("No active children at step %d.\n", query_step);
        return -1;
    }

    //srand(time(NULL) ^ 1500);
    int random_index = rand() % count; //choose a random number
    return active_children[random_index]; //return an active child based on the random number
}
