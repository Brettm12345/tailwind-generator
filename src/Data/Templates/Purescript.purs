module Data.Templates.Purescript (generate, save) where

import Prelude
import Data.String (joinWith)
import Data.TemplateString ((<^>))
import Data.Tuple (Tuple)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Node.Encoding (Encoding(..))
import Node.FS.Sync (writeTextFile)
import Node.Path (FilePath)
import Types (Class(..))

generate :: Array Class -> String
generate classes =
  """
module Tailwind (
  Tailwind,
  tailwind,
  tailwindMaybes,
  ${names}
) where

import Prelude ((<<<), map)

import Data.String as String
import Data.Array as Array
import Data.Maybe (Maybe)

newtype Tailwind
  = Tailwind String

unwrap :: Tailwind -> String
unwrap (Tailwind c) = c

tailwind :: Array Tailwind -> String
tailwind = String.joinWith " " <<< map unwrap

tailwindMaybes :: Array (Maybe Tailwind) -> String
tailwindMaybes = tailwind <<< Array.catMaybes
${classes}
"""
    <^> tokens
  where
  tokens :: Array (Tuple String String)
  tokens =
    [ "names" /\ (joinWith ",\n" $ indent <$> classes)
    , "classes" /\ (joinWith "" $ purify <$> classes)
    ]

  indent :: Class -> String
  indent (Class { name }) = ("  " <> name)

  purify :: Class -> String
  purify (Class { name, className }) =
    """
  ${name} :: Tailwind
  ${name} = Tailwind "${className}"
  """
      <^> [ "name" /\ name, "className" /\ className ]

save :: FilePath -> Array Class -> Effect Unit
save path = writeTextFile UTF8 path <<< generate
