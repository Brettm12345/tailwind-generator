let mkPackage =
      https://raw.githubusercontent.com/purescript/package-sets/psc-0.12.3-20190227/src/mkPackage.dhall sha256:0b197efa1d397ace6eb46b243ff2d73a3da5638d8d0ac8473e8e4a8fc528cf57

let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.13.6-20200123/packages.dhall sha256:687bb9a2d38f2026a89772c47390d02939340b01e31aaa22de9247eadd64af05

let overrides = {=}

let additions =
      { template-strings =
          mkPackage
            [ "functions", "tuples" ]
            "https://github.com/purescripters/purescript-template-strings"
            "v5.1.0"
      , transformerless =
          mkPackage
            [ "tuples", "tailrec" ]
            "https://github.com/Thimoteus/purescript-transformerless/"
            "v4.1.0"
      , simple-parser =
          mkPackage
            [ "strings", "lists", "unicode", "transformerless" ]
            "https://github.com/Thimoteus/purescript-simple-parser"
            "v8.0.0"
      }

in  upstream ⫽ overrides ⫽ additions
