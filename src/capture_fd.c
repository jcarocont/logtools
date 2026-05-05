#include <R.h>
#include <Rinternals.h>
#include <unistd.h>
#include <fcntl.h>
#include <pthread.h>
#include <stdio.h>
#include <string.h>

static int pipe_fd[2]    = {-1, -1};
static int saved_stdout  = -1;
static int saved_stderr  = -1;
static FILE *log_file    = NULL;
static pthread_t drain_thread;

static void *drain_loop(void *arg) {
    char buf[4096];
    ssize_t n;
    while ((n = read(pipe_fd[0], buf, sizeof(buf)-1)) > 0) {
        buf[n] = '\0';
        write(saved_stdout, buf, n);
        fwrite(buf, 1, n, log_file);
        fflush(log_file);
    }
    return NULL;
}

SEXP start_capture(SEXP path) {
    const char *fpath = CHAR(STRING_ELT(path, 0));

    if (pipe(pipe_fd) < 0)       error("No se pudo crear pipe");
    log_file = fopen(fpath, "w");
    if (!log_file)               error("No se pudo abrir archivo de log");

    saved_stdout = dup(STDOUT_FILENO);
    saved_stderr = dup(STDERR_FILENO);

    dup2(pipe_fd[1], STDOUT_FILENO);
    dup2(pipe_fd[1], STDERR_FILENO);
    close(pipe_fd[1]);
    pipe_fd[1] = -1;

    pthread_create(&drain_thread, NULL, drain_loop, NULL);

    return R_NilValue;
}

SEXP stop_capture(void) {
    /* restaurar fds — esto cierra el extremo escritura del pipe
       y el drain_loop recibe EOF y termina */
    dup2(saved_stdout, STDOUT_FILENO);
    dup2(saved_stderr, STDERR_FILENO);

    pthread_join(drain_thread, NULL);

    fclose(log_file);
    close(pipe_fd[0]);

    saved_stdout = saved_stderr = -1;
    log_file     = NULL;
    pipe_fd[0]   = -1;

    return R_NilValue;
}
