# Requirements

- Stack
- BNFC: https://bnfc.digitalgrammars.com/
- Alex
- Happy

# Setup

- First we will create the parser:
  - `cd grammar`
  - `bnfc --haskell -m CTT.cf`
  - `make`
  - `cp AbsCTT.hs ErrM.hs LexCTT.hs ParCTT.hs PrintCTT.hs SkelCTT.hs ../src`
- Then change back `cd ..` and create executable with `stack build`
- Run command with `stack exec ctt`. You can either pass input via stdin, or as
  a file:
  - `echo "(\ x.x)a" | stack exec ctt`
  - `stack exec ctt examples/test.ctt`
