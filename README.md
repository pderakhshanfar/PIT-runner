# PIT-runner

## Docker image
Build the docker image by running `build-image` script:

```
. scripts/docker/build-image.sh
```

Run docker containere by the `run-container` script:

```bash
. scripts/docker/run-container.sh <benchmark-dir> <sourcecode-dir> <tests-dir>
```

To remove the docker image and container, use `remove-image.sh` and `stop-rm-container.sh` scripts, respectively.

```bash
. scripts/docker/remove-image.sh
```

```bash
. scripts/docker/stop-rm-container.sh
```

## Compile and prepare tests

Run the following script

```
. scripts/docker/compile-tests.sh <first-execution-round> <last-execution-round> <console-log-name>
```

- `<first-execution-round>` and `<last-execution-round>` indicates the range of execution rounds that the script will prepare the tests.

- The execution log of the script will be saveed in `consoleLog/<console-log-name>.log`.

## Run PIT (mutation score calculator)

Run the following script

```
. scripts/docker/calculate-mutation-score.sh <first-execution-round> <last-execution-round> <number-of-parallel-processes> <console-log-name>
```

- <number-of-parallel-processes> indicates the number of PIT instances that can be executed simultaneously.

- The execution log of the script will be saveed in `consoleLog/<console-log-name>.log`.

- The results of PIT execution (including PIT execution logs + mutation score reports) will be saved in `pit-outputs` directory.
