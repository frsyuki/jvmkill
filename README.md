# Overview

**jvmkill** is a simple [JVMTI][] agent that forcibly terminates the JVM
when it is unable to allocate memory or create a thread. This is important
for reliability purposes: an `OutOfMemoryError` will often leave the JVM
in an inconsistent state. Terminating the JVM will allow it to be restarted
by an external process manager.

[JVMTI]: http://docs.oracle.com/javase/8/docs/technotes/guides/jvmti/

It is often useful to automatically dump the Java heap using the
`-XX:+HeapDumpOnOutOfMemoryError` JVM argument. This agent will be
notified and terminate the JVM after the heap dump completes.

A common alternative to this agent is to use the
`-XX:OnOutOfMemoryError` JVM argument to execute a `kill -9` command.
Unfortunately, the JVM uses the `fork()` system call to execute the kill
command and that system call can fail for large JVMs due to memory
overcommit limits in the operating system.  This is the problem that
motivated the development of this agent.

# Building

    make JAVA_HOME=/path/to/jdk

# Usage

Run Java with the agent added as a JVM argument:

    -agentpath:/path/to/libjvmkill.so

Alternatively, if modifying the Java command line is not possible, the
above may be added to the `JAVA_TOOL_OPTIONS` environment variable.

# Docker

Add following lines to Dockerfile to install jvmkill to /usr/local/lib/jvmkill.so:

    ADD https://github.com/frsyuki/jvmkill/raw/master/docker/install_jvmkill.sh install_jvmkill.sh
    RUN bash install_jvmkill.sh

Note that jvmkill doesn't work if java process runs as PID 1 (because Linux
kernel doesn't let user processes send KILL signal to PID 1). This is a problem
with Docker because Docker runs a process as PID 1 by default. You can add
`--init` option to `docker run` command so that an init process always runs as
PID 1 and java process runs as a child process.

