#include <stdio.h>
#include <mman.h>

struct Config {
  size_t length;
  long words;
  long primesFound;
  long topPrime;
  long goal;
  long *sieve;

  char *mmapFile;
} config;

void main(int argc, char *argv[], char *env[]) {
  configure(argc, argv, env);
}

// Eventually(?) this will be dynamic.
void configure main(int argc, char *argv[], char *env[]) {
  config.goal = 1000 * 1000;
  config.words = goal >> 5;
  config.length = words * sizeof sieve[0];

  config.mmapFile = "data";
}

void sieve_round() {

