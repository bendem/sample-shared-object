CC ?= gcc
CFLAGS ?= -g
#CFLAGS ?= -O3

CFLAGS += -Wall -Wpedantic -Wextra

.PHONY: all clean run-main run-main-with-rpath

all: main main-with-rpath

clean:
	rm -f main lib.so

run-main-with-rpath: main-with-rpath
	./main-with-rpath

run-main: main
	LD_LIBRARY_PATH=. ./main

debug-main-with-rpath: main-with-rpath
	ldd main-with-rpath

debug-main: main
	ldd main

#
# gcc
#    -Wl,option
#        Pass option as an option to the linker.  If option contains commas, it is split into multiple options at the commas.  You can use this syntax to pass an argument to the option.  For example, -Wl,-Map,output.map passes -Map
#        output.map to the linker.  When using the GNU linker, you can also get the same effect with -Wl,-Map=output.map.
#
# ld
#    -rpath=dir
#        Add a directory to the runtime library search path.  This is used when linking an ELF executable with shared objects.  All -rpath arguments are concatenated and passed to the runtime linker, which uses them to locate shared
#        objects at runtime.
#
#        The -rpath option is also used when locating shared objects which are needed by shared objects explicitly included in the link; see the description of the -rpath-link option.  Searching -rpath in this way is only supported
#        by native linkers and cross linkers which have been configured with the --with-sysroot option.
#
#        If -rpath is not used when linking an ELF executable, the contents of the environment variable "LD_RUN_PATH" will be used if it is defined.
#
#        The -rpath option may also be used on SunOS.  By default, on SunOS, the linker will form a runtime search path out of all the -L options it is given.  If a -rpath option is used, the runtime search path will be formed
#        exclusively using the -rpath options, ignoring the -L options.  This can be useful when using gcc, which adds many -L options which may be on NFS mounted file systems.
#
#        For compatibility with other ELF linkers, if the -R option is followed by a directory name, rather than a file name, it is treated as the -rpath option.
#
main-with-rpath: main.c lib.so
	$(CC) $(CFLAGS) -Wl,-rpath=. -o $@ $^

main: main.c lib.so
	$(CC) $(CFLAGS) -o $@ $^

%.so: %.c %.h
	$(CC) $(CFLAGS) -shared -o $@ -fPIC $^