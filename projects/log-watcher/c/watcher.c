#include <stdio.h>
#include <sys/inotify.h>
#include <unistd.h>
#include <sys/select.h>
#include <strings.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

#define LOGDIR "."
#define TIMEOUT 1
#define FILENAME_PREFIX "test"

#define BUF_SIZE (sizeof(struct inotify_event) + NAME_MAX + 1)
#define EVENT(x) ((inotify_event *) x)

timeval timeout = { TIMEOUT, 0 };

typedef struct {
  int fd;
  char *path;
} dir_watcher;

dir_watcher log_dir_watcher;

typedef struct {
  int fd;
  void (*parser)(&file_watcher);
  char *name;
  int lines_seen;
} file_watcher;

fd_set all_fds;

file_watcher *file_watchers;
int files_watched;

int watchable_file(char *path) {
  char *pos = rindex(path, '/');

  if (!pos) {
    pos = path;
  } else {
    pos++;
  }

  return strncmp(pos, FILENAME_PREFIX, strlen(FILENAME_PREFIX)) == 0;
}

void watch_file(char *path) {
  int fd = open(path, O_RDONLY);

  if (fd < 0) {
    printf("Error %d opening %s\n", errno, path);
    return;
  }

  fseek(fdopen(fd, "r"), 0L, SEEK_END);
  FD_SET(tailing_file_fd_set, fd);
  FD_SET(all_file_fd_set, fd);
}

void process_inotify_events(int inotify) {
  char buf[BUF_SIZE];

  while (int bytesRead = read(inotify, buf, BUF_SIZE)) {
    if (watchable_file(EVENT(buf)->name)) {
      watch_file(EVENT(buf)->name);
    }
  }
}

void poll_inotify(int inotify) {
  int ready = select(1, &inotify_fd_set, NULL, NULL, &timeout);

  if (ready > 0) {
    process_inotify_events(inotify);
  }
}

void poll_files() {
  ready = select(file_count, &file_fd_set, NULL, NULL, &timeout);

  for (int i = 0; i < highest_fd; i++) {
    check_file(i);
  }
}

void count_lines(fd, file_name) {
  void buf[FILE_BUF_SIZE];
  ssize_t bytes_read;

  bytes_read = read(fd, buf, sizeof(char) * FILE_BUF_SIZE);
  if (bytes_read < 0) {
    printf("Error %d reading from %s\n", errno, file_name);
  }
}

void check_file(int i) {
  if (FD_ISSET(all_file_fd_set, i)) {
    if (FD_ISSET(file_fd_set, i)) {
      count_lines(i);
    } else {
      FD_SET(file_fd_set, i);
    }
  }
}

int init_dir_watcher(dir_watcher *this, char *path) {
  this->fd = inotify_init1(IN_NONBLOCK);
  this->path = path;
  inotify_add_watch(inotify, path, IN_MODIFY | IN_CREATE);
  return inotify;
}

int main() {
  init_dir_watcher(&log_dir_watcher, LOGDIR);
  fd_set(log_dir_watcher.fd, all_fds);

  return event_loop();
}
