{-# LANGUAGE OverloadedStrings #-}

-- | New cabal makes a bunch of directory trees to hold
-- the products of computation, but doesn't tell you what/where
-- those files are, so we had to parse the output of the cabal run.
-- I discovered that dist-newstyle/cache/plan.json has all this
-- info, undocumented largely, but the info we need is there.
-- Parsing the json file is a little manual because there isn't
-- a Haskell type that represents everything.
-- I tried to parse it with aeson and ran into minutiae.
-- There may be a cabal function that reads this, though I only find the one that writes it out.



import Data.ByteString.Lazy as BS (ByteString, readFile)
import Data.Aeson (Object, Array, decode , (.:), FromJSON(..))
import Data.Aeson.Types (parseMaybe, Value(..))
import Data.Aeson.Types.Internal (prependFailure, typeMismatch)
import Data.HashMap.Strict (HashMap, lookup, toList)
import Data.Text

default (Text)

data InstallPlan = InstallPlan { ip :: Object }

instance FromJSON InstallPlan where
    parseJSON (Object v) = InstallPlan
        <$> ip .: "install-plan"
    -- We do not expect a non-Object value here.
    -- We could use empty to fail, but typeMismatch
    -- gives a much more informative error message.
    parseJSON invalid    =
        prependFailure "parsing Coord failed, "
            (typeMismatch "Object" invalid)

test = test' "dist-newstyle/cache/plan.json"
test' fp = do
  bs <- BS.readFile fp
  let mo = (decode bs :: Maybe Object)
  let ip = mo >>= installPlan
  print ip

installPlan :: Object -> Maybe Array
installPlan result = flip parseMaybe result $ \obj -> do
  ip <- obj .: "install-plan"
  return (ip)
  -- distDir <- (obj .: "dist-dir")
  -- binFile <- obj .: "bin-file"
  -- return (distDir, binFile)
