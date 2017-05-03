/**
 * tmux2.c
 *
 * Execute "tmux -2" in a single program with no additional parameter.
 * For using tmux in Guake.
 *
 * How to Install
 *
 * gcc tmux2.c -o tmux2
 * sudo mv tmux2 /usr/local/bin
 * sudo sh -c 'echo "/usr/local/bin/tmux2" >> /etc/shells'
 *
 * Then select /usr/local/bin/tmux2 in Guake's configuration.
 *
 */

#include <stdio.h>
#include <unistd.h>

int main(){
  int res=0;
  int status=0;

  char *path = "/usr/bin/tmux";
  char *arg0 = "tmux";
  char *arg1 = "-2";

  execl(path, arg0, arg1, NULL);
}
