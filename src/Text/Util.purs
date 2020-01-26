module Text.Util (capitalize) where

import Prelude
import Data.Maybe (Maybe)
import Data.String.CodeUnits as String
import Data.Char.Unicode (toUpper)

capitalize :: String -> Maybe String
capitalize = map (\a -> (String.singleton (toUpper a.head)) <> a.tail) <<< String.uncons
