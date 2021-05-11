{-# LANGUAGE OverloadedStrings, DeriveGenerics, StandaloneDeriving #-}

import Data.ByteString.Lazy as BS (ByteString, readFile)
import Data.Aeson (Object, Array, decode , (.:), FromJSON(..))
import Data.Aeson.Types (parseMaybe, Value(..))
import Data.Aeson.Types.Internal (prependFailure, typeMismatch)
import Data.HashMap.Strict (HashMap, lookup, toList)
import Data.Text
import GHC.Generic

default (Text)

test = test' "dist-newstyle/cache/plan.json"
test' fp = do
  bs <- BS.readFile fp
  let Just o = (decode bs :: Maybe Value)
  let mp = f o
  print p

f :: Value -> Maybe (Text, Text)
f v = case v of
  Object o -> return (Just ("x","y"))
  _ -> error "

installPlan :: Object -> Maybe Array
installPlan result = flip parseMaybe result $ \obj -> do
  ip <- obj .: "install-plan"
  return (ip)
  -- distDir <- (obj .: "dist-dir")
  -- binFile <- obj .: "bin-file"
  -- return (distDir, binFile)
