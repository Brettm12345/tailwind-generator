module Test.Text.Util where

import Prelude
import Data.Maybe (Maybe(..))
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)
import Text.Util (capitalize)

spec :: Spec Unit
spec =
  describe "Capitalize" do
    let
      expected = Just "Test"
    it "Handles strings" do
      (capitalize "test") `shouldEqual` expected
    it "Makes the rest of the string lowercase" do
      (capitalize "teSt") `shouldEqual` expected
