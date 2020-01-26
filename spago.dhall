{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "my-project"
, dependencies =
    [ "console"
    , "effect"
    , "node-fs"
    , "optparse"
    , "psci-support"
    , "simple-parser"
    , "string-parsers"
    , "template-strings"
    ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
