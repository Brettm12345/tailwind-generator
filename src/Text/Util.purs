module Text.Util (capitalize) where

import Prelude
import Data.Char.Unicode (toUpper)
import Data.Maybe (Maybe)
import Data.String.CodeUnits (singleton, uncons)

capitalize :: String -> Maybe String
capitalize = map f <<< uncons
  where
  f ({ head, tail }) = singleton (toUpper head) <> tail
