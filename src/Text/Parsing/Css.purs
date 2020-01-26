module Text.Parsing.Css
  ( parseName, parseClass
  ) where

import Prelude
import Control.Alt ((<|>))
import Data.Array as Array
import Data.List (elem, many)
import Data.Maybe (fromMaybe, isNothing)
import Data.Monoid (guard)
import Data.String (Pattern(..), Replacement(..), joinWith, replaceAll)
import Text.Parsing.Simple (Parser, char, int, optionMaybe, satisfy, skipSpaces, someChar, string, word)
import Text.Util (capitalize)

type StringParser
  = Parser String String

-- | Parse each value until we hit a separator
parseStr :: StringParser
parseStr = someChar <<< satisfy $ not <<< isSeparator
  where
  isSeparator :: Char -> Boolean
  isSeparator = (_ `elem` [ ':', ' ', '\\', '-', '{', '\n' ])

-- | Handle negative values. For example .-bm-16 would parse to mNeg16
parseNegative :: StringParser
parseNegative = do
  _ <- char '-'
  str <- parseStr
  pure $ str <> "Neg"

parseNumber :: StringParser
parseNumber = show <$> int

-- | Handle fraction values. For example .w-11/12 would become w11Over12
parseFraction :: StringParser
parseFraction = do
  x <- parseNumber
  _ <- string "\\/"
  y <- parseNumber
  pure $ x <> "Over" <> y

handleStr :: StringParser
handleStr = parseNegative <|> parseStr

modifier :: StringParser
modifier = do
  x <- optionMaybe $ string "\\:"
  _ <- guard (isNothing x) $ string "-"
  str <- fromMaybe "" <<< capitalize <$> (handleStr <|> parseNumber <|> parseFraction)
  pure str

-- | Parse the tailwind class name
parseClass :: StringParser
parseClass = do
  skipSpaces
  _ <- char '.'
  replaceAll (Pattern "\\") (Replacement "") <$> word

-- | Parse the function name
parseName :: StringParser
parseName = do
  skipSpaces
  _ <- char '.'
  name <- handleStr
  modifiers <- Array.fromFoldable <$> many modifier
  pure $ name <> joinWith "" modifiers
