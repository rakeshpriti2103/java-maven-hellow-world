# Hello World Java Maven project
Super basic project to test deployment as a standalone app on a container.
The usual jar artificat `app.jar` will be replaced by the one `jar-with-dependencies` so it can be executed.

## Pre-requisites
- Docker


## Running
Building the image. Navigate to the root folder of the project where the `Dockerfile` is located and execute the following command.

```bash
$ docker image build --tag hello-world-jdk8 .
```
If everything went well, you should see the following line in your terminal:

```bash
Successfully tagged hello-world-jdk8:latest
```

To verify that your image has been built, you can access your image list by typing:

```bash
$ docker image ls

REPOSITORY          TAG                 IMAGE ID            CREATED              SIZE
hello-world-jdk8    latest              9966fb7ed7a8        About a minute ago   150MB
openjdk             8-jdk-alpine        a3562aa0b991        12 months ago        105MB
```

To check if the image is OK, run it with the following command:
```bash
$ docker run --detach hello-world-jdk8
````

If everything is OK you should see a `Hello World!` at the console

To run a container based on that image you can type the following command:
```bash
$ docker container run --detach -t hello-world-jdk8 bash

-d, --detach   Run container in background andprint container ID`
-t, --tty      Allocate a pseudo-TTY`

So the container should appear in the list of containers displayed when running the following:

```bash
$ docker container ps -l

CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
2c4f8aa9c5cd        hello-world-jdk8    "bash"              3 minutes ago       Up 3 minutes                            reverent_jackson

Usefull options
-a, --all               Show all containers (default shows just running)
-f, --filter filter     Filter output based on conditions provided
--format string         Pretty-print containers using a Go template
-n, --last int          Show n last created containers (includes all states) (default -1)
-l, --latest            Show the latest created container (includes all states)
```

To access the container and execute some bash commands (e.g. to validate the resulting `.jar`)

```bash
$ docker exec -it <CONTAINER ID> bash

bash-4.4# **<you are good to execute Linux commands>**

-i, --interactive   Keep STDIN open even if not attached
    --privileged    Give extended privileges to the command
-t, --tty           Allocate a pseudo-TTY
```
