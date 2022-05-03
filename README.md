# Xojo on Docker

Docker images to run [Xojo](https://xojo.com/) IDE and desktop apps.

## Images

All images are hosted on [Docker Hub](https://hub.docker.com/r/kmaehashi/xojo-docker).

* `desktop-runtime`: image to run desktop apps
* `xojo-{VERSION}`: image to run Xojo IDE
    * These images are based on `desktop-runtime` image.

## Usage

### Via X11 Forwarding

First connect to the Docker host with SSH X11 forwarding enabled.

```sh
ssh -Y host
```

Then start the container to run Xojo IDE.

```sh
docker run \
    --rm \
    --net host \
    --env DISPLAY \
    --volume ~/.Xauthority:/root/.Xauthority \
    kmaehashi/xojo-docker:xojo-2019r2
```

Notes:

* `--net host`: The container shares the same network namespace as the Docker host.
  This is mandatory to connect to a TCP port for X11 forwarding from the container, as the port only binds to `localhost` of the Docker host.
* `--env DISPLAY`: X11 applications (i.e., Xojo IDE) use this information to know the TCP port for X11 forwarding.
* `--volume ~/.Xauthority:/root/.Xauthority`: X11 applications inside the container use this file as the authorization cookie to the forwarded X11 server.

Remote Debugger can also be run inside the container.

```sh
docker run \
    --rm \
    --net host \
    --env DISPLAY \
    --volume ~/.Xauthority:/root/.Xauthority \
    kmaehashi/xojo-docker:xojo-2019r2 \
    "/opt/xojo/xojo/Extras/Remote Debugger Desktop/Remote Debugger Desktop 64-Bit/Remote Debugger Desktop"
```

TODO verify how to use the debugger

To run your application instead of the IDE, specify the application path as an argument.
You can use `desktop-runtime` image, which provides smaller footprint than `xojo-{VERSION}` images.

```sh
docker run \
    --rm \
    --net host \
    --env DISPLAY \
    --volume ~/.Xauthority:/root/.Xauthority \
    --volume /local/path/to/app_dir:/container/path/to/app_dir \
    kmaehashi/xojo-docker:desktop-runtime \
    /container/path/to/app_dir/app
```

Hints:

* Make sure that `xauth` command is available on the Docker host when using SSH X11 forwarding.
* SELinux may prevent accessing `.Xauthority` from inside Docker containers.
* Containers launched using the `docker` command line above are volatile as `--rm` option is specified.
  Consider specifying additional volumes to keep your Xojo configuration and projects outside of the container.
  The IDE stores preferences (including licenses) under `/root`.
* `/opt/xojo/xojo` is a symbolic link to the current Xojo root directory (e.g., `/opt/xojo/xojo/xojo2019r2`).
* To install additional plugins you will need a custom Dockerfile based on `xojo-VERSION` image.
  Place plugin files (`*.xojo_plugin`) under `/opt/xojo/xojo/Plugins/`.

### Headless Mode

You can run your desktop application in headless (no-display) mode for e.g. testing purposes or contiguous integration systems.
Before starting your application you need to source the [`headless`](desktop-runtime/headless) script, which internally configures a virtual X11 server (`Xvfb`).

```sh
docker run \
    --rm \
    --volume /local/path/to/app_dir:/container/path/to/app_dir \
    kmaehashi/xojo-docker:desktop-runtime \
    bash -c 'source /headless; /container/path/to/app_dir/app'
```

Hints:

* Use `System.DebugLog` method in Desktop apps to print to the standard output.
* You can access the command line arguments via `/proc/self/cmdline`, e.g.:

```xojo
Public Function Arguments() as String()
  Var ret() As String

  #if TargetLinux And TargetDesktop
    Var s As TextInputStream = TextInputStream.Open(New FolderItem("/proc/self/cmdline"))
    Try
      Var chunks() As String
      While True
        Var buf As String = s.Read(12)
        If buf.Length = 0 Then Exit
        chunks.Append(buf)
      Wend
      ret = String.FromArray(chunks, "").Split(Chr(0))
    Finally
      s.Close()
    End Try
  #endif

  Return ret
End Function
```

### Debug-Running Projects

Debug-run your application inside the Docker container, using the project source code and Xojo IDE.

TODO

```sh
cat _EOF_ | nc -U /tmp/XojoIDE
OpenFile("/path/to/project")
DoCommand("RunApp")
_EOF_
```

(You must have read and accept EULA of Xojo IDE before using `xojo-accept-eula` command)
