# Xojo on Docker

Docker images to run [Xojo](https://xojo.com/) IDE and desktop apps.

## Images

All images are hosted on [Docker Hub](https://hub.docker.com/r/kmaehashi/xojo-docker).

* `desktop-runtime`: image to run desktop apps
* `xojo-{VERSION}`: image to run Xojo IDE
    * These images are based on `desktop-runtime` image.

## Usage

### X11 Forwarding

First connect to the Docker host with SSH X11 forwarding enabled.

```sh
ssh -Y host
```

Then run Xojo IDE, exposing the forwarded display.

```sh
docker run \
    --rm \
    --net host \
    --env DISPLAY \
    --volume ~/.Xauthority:/root/.Xauthority \
    kmaehashi/xojo-docker:xojo-2019r2
```

You can also run the Remote Debugger:

```sh
docker run \
    --rm \
    --net host \
    --env DISPLAY \
    --volume ~/.Xauthority:/root/.Xauthority \
    kmaehashi/xojo-docker:xojo-2019r2 \
    "/opt/xojo/xojo/Extras/Remote Debugger Desktop/Remote Debugger Desktop 64-Bit/Remote Debugger Desktop"
```

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
* Containers launched using the command line above are volatile as `--rm` option is given.
  Consider specifying additional volumes to keep your data outside of the container.
  Note that Xojo IDE stores preferences and licenses under `/root`.
* To install additional plugins you will need a custom Dockerfile based on `xojo-VERSION` image; place `*.xojo_plugin` under `/opt/xojo/xojo/Plugins/`.

### Headless Mode

You can run your application in headless (no-display) mode for e.g. tesitng purposes.
Before starting your application you need to source the [`headless`](desktop-runtime/headless) script, which internally configures a virtual X11 server (`Xvfb`).

```sh
docker run \
    --rm \
    --volume /local/path/to/app_dir:/container/path/to/app_dir \
    kmaehashi/xojo-docker:desktop-runtime \
    bash -c 'source /headless; /container/path/to/app_dir/app'
```

Hints:

* You can print to the standard output via `System.DebugLog` method in Desktop apps.
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
