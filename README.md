# md-exec

Make Markdown files executable.

```console
$ cat examples/fizzbuzz.md
# fizzbuzz

Prints the numbers from 1 to N, one per line, where N is the first
command-line argument (default 100).
...
$ chmod +x examples/fizzbuzz.md
$ ./examples/fizzbuzz.md 5
md-exec: compiling examples/fizzbuzz.md with claude...
1
2
Fizz
4
Buzz
```

`md-exec` is registered with the kernel's
[binfmt_misc](https://docs.kernel.org/admin-guide/binfmt-misc.html) as the
interpreter for files ending in `.md`. When you exec one, it sends the
Markdown to the `claude` CLI, which works out what program the document
describes and writes it in Python. That Python is then run with your
arguments, stdin and stdout.

Documents that aren't really programs get the program that best "performs"
them: try `./examples/pancakes.md`.

## Install

Requires Linux, Python 3, and an authenticated `claude` CLI on your `PATH`.

```sh
sudo ./install.sh     # installs /usr/local/bin/md-exec, registers .md
sudo ./uninstall.sh   # undoes it
```

The registration is persisted in `/etc/binfmt.d/md-exec.conf` for
systemd-binfmt. Without installing, you can run `./md-exec FILE.md [ARGS...]`
directly.

## Caching

Generated scripts are cached in `~/.cache/md-exec/`, keyed by a SHA-256 of
the file's contents, the system prompt, and the model. Re-running an
unchanged file runs the same script without calling Claude; editing the file
produces a new one. Concurrent first runs of the same file share a lock, so
Claude is only called once.

## Options

| Variable               | Effect                                              |
| ---------------------- | --------------------------------------------------- |
| `MD_EXEC_SHOW=1`       | Print the generated script instead of running it.   |
| `MD_EXEC_REGENERATE=1` | Ignore the cache and generate a fresh script.       |
| `MD_EXEC_MODEL`        | Model to pass to `claude --model`.                  |
| `MD_EXEC_CACHE_DIR`    | Cache location (default `$XDG_CACHE_HOME/md-exec`). |

## A word of caution

This runs code an LLM wrote, unreviewed, with your privileges, whenever an
executable `.md` file is exec'd — including ones that came from someone else.
Use `MD_EXEC_SHOW=1` to read a script before running it, and keep the
executable bit off Markdown you don't trust.
