{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "my-project"
, dependencies =
    [ "aff"
    , "console"
    , "effect"
    , "node-fs"
    , "optparse"
    , "psci-support"
    , "simple-parser"
    , "spec"
    , "spec-discovery"
    , "string-parsers"
    , "template-strings"
    ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
