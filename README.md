= What is this

Tock application binaries require applications to be linked at a very
specific address. This turns out to be pretty fragile since it requires
guessing/figuring out what addresses to use and then hoping nothing changes
to throw it off. This is a proof of concept/pile of hacks to show what reliable
linking might look like

The step are roughly:

- Build the app with a guess of what addresses we should be using
- Parse the output of `elf2tab` to get the (correct) size of the header
- Check the associated kernel binary to see where the app memory actually starts- Substitutes those values back into the linker script
- Build the app again, hopefully linked at the correct address.

This at least prevents problems like the binary no longer working if the
app name changes but there's certainly room for improvement.
