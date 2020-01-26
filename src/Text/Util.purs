module Text.Util (capitalize) where

import Prelude
import Data.Char.Unicode (toLower, toUpper)
import Data.Maybe (Maybe)
import Data.String.CodeUnits (fromCharArray, singleton, toCharArray, uncons)

capitalize :: String -> Maybe String
capitalize = map f <<< uncons
  where
  f :: { head :: Char, tail :: String } -> String
  f ({ head, tail }) = handleHead head <> handleTail tail

  handleHead :: Char -> String
  handleHead = singleton <<< toUpper

  handleTail :: String -> String
  handleTail = fromCharArray <<< map toLower <<< toCharArray
