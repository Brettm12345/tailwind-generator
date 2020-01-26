module Test.Main where

import Prelude
import Css (parseClass)
import Data.String (joinWith)
import Effect (Effect)
import Effect.Console (log)
import Options.Applicative.Internal.Utils (lines)
import Text.Parsing.Simple (parse)

main :: Effect Unit
main = do
  log $ joinWith "\n" $ map doParse $ lines testString
  where
  doParse = show <<< parse parseClass

  testString =
    """
  .placeholder-blue-100::-ms-input-placeholder
  .pb-24
  .-m-16
  .xl\:-m-1
  .xl\:-m-px
  .w-11\/12
  .xl\:hover\:text-gray-500:hover
  .xl\:focus\:placeholder-gray-300:focus::placeholder
  """
