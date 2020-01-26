module Main where

import Prelude
import Control.Monad.Transformerless.Except (Except, runExcept)
import Css (parseClass, parseName)
import Data.Either (hush)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.String (joinWith)
import Effect (Effect)
import Effect.Class.Console (logShow)
import Effect.Console (log)
import Node.Encoding (Encoding(..))
import Node.FS.Sync (readFile, readTextFile, writeTextFile)
import Node.Path (FilePath)
import Options.Applicative (Parser, ParserInfo, ReadM, command, completeWith, execParser, fullDesc, help, helper, info, long, maybeReader, metavar, option, progDesc, short, showDefault, strOption, subparser, switch, value, (<**>))
import Options.Applicative.Internal.Utils (lines)
import Templates.Purescript as Purescript
import Text.Parsing.Simple (parse)
import Types (Class(..))

data Lang
  = ReasonML
  | Purescript
  | Elm
  | Typescript

derive instance genericLang :: Generic Lang _

instance showLang :: Show Lang where
  show = genericShow

readLang :: String -> Maybe Lang
readLang = case _ of
  "reasonml" -> Just ReasonML
  "purescript" -> Just Purescript
  "elm" -> Just Elm
  "typescript" -> Just Typescript
  _ -> Nothing

languages :: Array String
languages = [ "reasonml", "purescript", "elm", "typescript" ]

parseLang :: ReadM Lang
parseLang = maybeReader readLang

data Args
  = Args
    { lang :: Lang
    , config :: FilePath
    , output :: FilePath
    , cssInput :: FilePath
    , cssOutput :: FilePath
    }

derive instance genericArgs :: Generic Args _

instance showArgs :: Show Args where
  show = genericShow

args :: Parser Args
args = ado
  lang <-
    option parseLang
      ( short 'l'
          <> long "lang"
          <> help "The language to generate code for"
          <> metavar (joinWith "|" languages)
          <> completeWith languages
      )
  config <-
    strOption
      ( short 'c'
          <> long "config"
          <> metavar "FILE"
          <> help "The path to tailwind.config.js"
          <> value "./tailwind.config.js"
          <> showDefault
      )
  output <-
    strOption
      ( short 'o'
          <> long "output"
          <> metavar "FILENAME"
          <> help "The directory for the generated code"
          <> value "./src"
          <> showDefault
      )
  cssInput <-
    strOption
      ( long "cssInput"
          <> metavar "FILE"
          <> help "The full path to the input stylesheet"
      )
  cssOutput <-
    strOption
      ( long "cssOutput"
          <> metavar "FILE"
          <> help "The full path to the generated stylesheet"
          <> value "./tailwind.css"
          <> showDefault
      )
  in Args { lang, config, output, cssInput, cssOutput }

opts :: ParserInfo Args
opts =
  info (args <**> helper)
    (fullDesc <> progDesc "Generates code and css from tailwind config")

generate :: FilePath -> Lang -> Array Class -> Effect Unit
generate path lang = writeTextFile UTF8 path <<< fn lang
  where
  fn = case _ of
    Purescript -> Purescript.generate
    ReasonML -> Purescript.generate
    Elm -> Purescript.generate
    Typescript -> Purescript.generate

coerceExcept :: forall e. Except e String -> String
coerceExcept = fromMaybe "" <<< hush <<< runExcept

handleArgs :: Args -> Effect (Array String)
handleArgs (Args { cssOutput, lang }) = do
  input <- readTextFile UTF8 cssOutput
  pure $ parsers <*> lines input
  where
  doParse f = coerceExcept <<< parse f

  parsers = map doParse [ parseName, parseClass ]

main :: Effect Unit
main = do
  r <- execParser opts
  result <- handleArgs r
  log $ joinWith "\n" result
