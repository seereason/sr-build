{-# LANGUAGE OverloadedStrings, DeriveGeneric, StandaloneDeriving #-}

import Data.ByteString.Lazy as BS (ByteString, readFile)
import Data.Aeson (Object, Array, decode , (.:), FromJSON(..))
import Data.Aeson.Types (parseMaybe, Value(..))
import Data.HashMap.Strict (HashMap, lookup, toList)
import Data.Text
import Data.Vector as V
import GHC.Generics

default (Text)

data InstallPlan = InstallPlan { ip :: Array } deriving (Show, Generic)

instance FromJSON InstallPlan where
    parseJSON (Object v) = InstallPlan
        <$> (v .: "install-plan")
    -- We do not expect a non-Object value here.
    -- We could use empty to fail, but typeMismatch
    -- gives a much more informative error message.
    parseJSON invalid    = fail "parsing InstallPlan failed"

test = test' "dist-newstyle/cache/plan.json"
test' fp = do
  bs <- BS.readFile fp
  let mo = (decode bs :: Maybe InstallPlan)
  case mo of
    Just o -> print (ip o) -- (V.map (\v -> v .: "dist-dir")  (ip o))
    Nothing -> print "Nothing"

print' a = print a >> putStrLn ""
