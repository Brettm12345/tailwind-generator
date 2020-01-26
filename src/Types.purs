module Types where

import Prelude
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)

data Class
  = Class
    { name :: String
    , className :: String
    }

derive instance genericClass :: Generic Class _

instance showClass :: Show Class where
  show = genericShow
