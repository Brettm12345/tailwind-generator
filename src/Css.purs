module Css
  ( parseName, parseClass
  ) where

import Prelude
import Control.Alt ((<|>))
import Data.Array as Array
import Data.Char.Unicode (toUpper)
import Data.List (elem, many)
import Data.Maybe (Maybe, fromMaybe, isNothing)
import Data.Monoid (guard)
import Data.String (Pattern(..), Replacement(..), joinWith, replaceAll)
import Data.String.CodeUnits as String
import Text.Parsing.Simple (Parser, char, int, optionMaybe, satisfy, skipMany, skipSpaces, someChar, space, string, word)

spaces :: Parser String Unit
spaces = skipMany space

separators :: Array Char
separators = [ ':', ' ', '\\', '-', '{', '\n' ]

isSeparator :: Char -> Boolean
isSeparator = (_ `elem` separators)

parseStr :: Parser String String
parseStr = someChar (satisfy (not <<< isSeparator))

parseNegative :: Parser String String
parseNegative = do
  _ <- char '-'
  str <- parseStr
  pure $ str <> "Neg"

parseNumber :: Parser String String
parseNumber = show <$> int

parseFraction :: Parser String String
parseFraction = do
  x <- parseNumber
  _ <- string "\\/"
  y <- parseNumber
  pure $ x <> "Over" <> y

handleStr :: Parser String String
handleStr = parseNegative <|> parseStr

capitalize :: String -> Maybe String
capitalize = map (\a -> (String.singleton (toUpper a.head)) <> a.tail) <<< String.uncons

modifier :: Parser String String
modifier = do
  x <- optionMaybe (string "\\:")
  _ <- guard (isNothing x) (string "-")
  str <- fromMaybe "" <<< capitalize <$> (handleStr <|> parseNumber <|> parseFraction)
  pure str

parseClass :: Parser String String
parseClass = do
  skipSpaces
  _ <- char '.'
  replaceAll (Pattern "\\") (Replacement "") <$> word

parseName :: Parser String String
parseName = do
  skipSpaces
  _ <- char '.'
  name <- handleStr
  modifiers <- Array.fromFoldable <$> many modifier
  pure $ name <> joinWith "" modifiers
