Idris basics for the brain dead:

# Installation

Install should be simple:

```bash
$ cabal update
$ cabal install idris

### if you've got cutting edge GHC, you might need to try
$ cabal install --allow-newer idris

### but after multiple dead ends sitting on GHC latest (8.10.2) i bumped down to recommended (8.8.4)
```

But, among other things, I found I needed to hack a core OSX library:
`/Library/Developer/CommandLineTools/SDKs/MacOSX10.15.sdk/System/Library/Frameworks/Security.framework/Headers/Authorization.h:180`
because I'm using GCC instead of CLANG, I guess?  See bug ticket linked below.

```c
// SDN 09/29/20
// GCC HACK: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=93082
// static const size_t kAuthorizationExternalFormLength = 32;
enum {
  kAuthorizationExternalFormLength = 32
};
```

(This probably got overwritten: I've since re-installed the CommandLineTools.  ::shrug emoji::)

That worked!  But then I noticed when running some basic Idris code that required
OS-integration, that I flooded with warnings from linked core C code (like `stdlib.h`)
about nullability completeness and such (like https://stackoverflow.com/q/58429844).

I first thought this was an issue with `gcc` and the standard libraries, and that
the GHC backend (RTS?) was tangled up with that.

I experimented with passing extra C compiler flags to GHC via its settings file, located at
`~/.ghcup/ghc/8.8.4/lib/settings`, reinstalling Idris (repeatedly), to no avail.

But then I realized that my `gcc` _doesn't_ produce those warnings, but my `clang` _does_,
so somewhere `clang` was getting involved.

I finally stumbled into the [Idris Compiler Documentation](http://docs.idris-lang.org/en/latest/reference/compilation.html#environment-variables)
and discovered that _Idris_ is the one that's calling the C compiler and would you know,
[it defaults to `cc` in most cases](https://github.com/idris-lang/Idris-dev/blob/5ea1a35b139c1a4d5fec81c2b047f41642d42747/src/IRTS/System.hs#L63).

So the trick ended up being:

```bash
$ export IDRIS_CC="gcc"
```

And voilà - warnings gone in Idris REPL _and_ static compiler.

# Running Idris

* starting REPL is just `idris`
* quitting is `:q` or `:quit`
* help is `:?` or `:h` or `:help`
* loading module in REPL is `idris hello.idr` then `:exec` in prompt
* reloading module in prompt is `:r`
* compiling to executable is:
```bash
$ idris hello.idr -o hello
$ ./hello
```
