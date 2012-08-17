#!/bin/bash

echo -ne \\E]P8002b36 # base03 (brblack)
## I don't know how to set the background to bold black, so instead I'm
## assigning base03 to both black and bold black.
# echo -ne \\E]P0073642 # base02 (black)
echo -ne \\E]P0002b36 # base03 (black workaround)
echo -ne \\E]Pa586e75 # base01 (brgreen)
echo -ne \\E]Pb657b83 # base00 (bryellow)
echo -ne \\E]Pc839496 # base0 (brblue)
echo -ne \\E]Pe93a1a1 # base1 (brcyan)
echo -ne \\E]P7eee8d5 # base2 (white)
echo -ne \\E]Pffdf6e3 # base3 (brwhite)
echo -ne \\E]P3b58900 # yellow (yellow)
echo -ne \\E]P9cb4b16 # orange (brred)
echo -ne \\E]P1dc322f # red (red)
echo -ne \\E]P5d33682 # magenta (magenta)
echo -ne \\E]Pd6c71c4 # violet (brmagenta)
echo -ne \\E]P4268bd2 # blue (blue)
echo -ne \\E]P62aa198 # cyan (cyan)
echo -ne \\E]P2859900 # green (green)

setterm -foreground blue
setterm -bold
setterm -store
