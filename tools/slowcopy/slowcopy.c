#include <stdio.h>
#include <stdlib.h>
#include <time.h>

static void msleep(long ms)
{
    struct timespec ts = {
        .tv_sec  = ms / 1000,
        .tv_nsec = (ms % 1000) * 1000000L,
    };
    while (nanosleep(&ts, &ts) == -1)
        continue;
}

int main(int argc, char **argv)
{
    const char *inpath  = NULL;
    const char *outpath = NULL;
    long cr_delay = 150;

    for (int i = 1; i < argc; i++) {
        if (argv[i][0] == '-') {
            if (argv[i][1] == 'r' && i + 1 < argc) {
                cr_delay = atol(argv[++i]);
            }
        } else if (inpath == NULL) {
            inpath = argv[i];
        } else if (outpath == NULL) {
            outpath = argv[i];
        }
    }

    if (!inpath || !outpath) {
        fprintf(stderr, "Usage: %s [-r ms] <input> <output>\n", argv[0]);
        return 1;
    }

    FILE *in = fopen(inpath, "rb");
    if (!in) {
        perror("fopen input");
        return 1;
    }

    FILE *out = fopen(outpath, "wb");
    if (!out) {
        perror("fopen output");
        fclose(in);
        return 1;
    }

    int c;
    while ((c = fgetc(in)) != EOF) {
        fputc(c, out);
        fflush(out);

        if (c == 0x0D)
            msleep(cr_delay);

        msleep(10);  /* 100 chars/sec */
    }

    fclose(in);
    fclose(out);
    return 0;
}
