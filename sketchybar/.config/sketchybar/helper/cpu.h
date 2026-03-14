#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <mach/mach.h>
#include <stdbool.h>
#include <time.h>


#define MAX_TOPPROC_LEN 28
#define TOPPROC_INTERVAL 4  /* run ps only every N updates to reduce CPU cost */

static const char TOPPROC[] = { "/bin/ps -Aceo pid,pcpu,comm -r" };
static const char FILTER_PATTERN[] = { "com.apple." };

struct cpu {
  host_t host;
  mach_msg_type_number_t count;
  host_cpu_load_info_data_t load;
  host_cpu_load_info_data_t prev_load;
  bool has_prev_load;
  uint32_t update_count;
  char last_topproc[MAX_TOPPROC_LEN + 4];
  char command[256];
};

static inline void cpu_init(struct cpu* cpu) {
  cpu->host = mach_host_self();
  cpu->count = HOST_CPU_LOAD_INFO_COUNT;
  cpu->has_prev_load = false;
  cpu->update_count = 0;
  snprintf(cpu->last_topproc, sizeof(cpu->last_topproc), "-");
  snprintf(cpu->command, 100, "");
}

static inline void cpu_update(struct cpu* cpu) {
  kern_return_t error = host_statistics(cpu->host,
                                        HOST_CPU_LOAD_INFO,
                                        (host_info_t)&cpu->load,
                                        &cpu->count                );

  if (error != KERN_SUCCESS) {
    printf("Error: Could not read cpu host statistics.\n");
    return;
  }

  if (cpu->has_prev_load) {
    uint32_t delta_user = cpu->load.cpu_ticks[CPU_STATE_USER]
                          - cpu->prev_load.cpu_ticks[CPU_STATE_USER];

    uint32_t delta_system = cpu->load.cpu_ticks[CPU_STATE_SYSTEM]
                            - cpu->prev_load.cpu_ticks[CPU_STATE_SYSTEM];

    uint32_t delta_idle = cpu->load.cpu_ticks[CPU_STATE_IDLE]
                          - cpu->prev_load.cpu_ticks[CPU_STATE_IDLE];

    double user_perc = (double)delta_user / (double)(delta_system
                                                     + delta_user
                                                     + delta_idle);

    double sys_perc = (double)delta_system / (double)(delta_system
                                                      + delta_user
                                                      + delta_idle);

    double total_perc = user_perc + sys_perc;

    cpu->update_count++;
    bool run_ps = (cpu->update_count % TOPPROC_INTERVAL == 1);

    if (run_ps) {
      FILE* file = popen(TOPPROC, "r");
      if (file) {
        char line[1024];
        fgets(line, sizeof(line), file);
        fgets(line, sizeof(line), file);
        char* start = strstr(line, FILTER_PATTERN);
        uint32_t caret = 0;
        size_t len = strlen(line);
        for (size_t i = 0; i < len && caret <= MAX_TOPPROC_LEN + 2; i++) {
          if (start && i == (size_t)(start - line)) {
            i += 8;
            continue;
          }
          if (caret >= MAX_TOPPROC_LEN && caret <= MAX_TOPPROC_LEN + 2) {
            cpu->last_topproc[caret++] = '.';
            continue;
          }
          cpu->last_topproc[caret++] = line[i];
          if (line[i] == '\0') break;
        }
        cpu->last_topproc[MAX_TOPPROC_LEN + 3] = '\0';
        pclose(file);
      }
    }

    const char* c = NULL;
    if (total_perc >= .7) {
      c = getenv("RED");
    } else if (total_perc >= .3) {
      c = getenv("ORANGE");
    } else if (total_perc >= .1) {
      c = getenv("YELLOW");
    } else {
      c = getenv("LABEL_COLOR");
    }
    if (!c) c = "0xffe0e0e0";

    snprintf(cpu->command, 256, "--push cpu.sys %.2f "
                                "--push cpu.user %.2f "
                                "--set cpu.top label='%s' "
                                "--set cpu.percent label=%.0f%% label.color=%s ",
                                sys_perc,
                                user_perc,
                                cpu->last_topproc,
                                total_perc * 100.,
                                c);
  }
  else {
    snprintf(cpu->command, 256, "");
  }

  cpu->prev_load = cpu->load;
  cpu->has_prev_load = true;
}
