{-# LANGUAGE DeriveAnyClass, DeriveLift, DeriveGeneric, OverloadedStrings, StandaloneDeriving, TemplateHaskell, UndecidableInstances #-}

-- common

module SeeReason.ProgramVersion
  ( ProgramVersion(..)
  ) where

import Data.Text (Text)
import GHC.Generics
import Data.SafeCopy
import Data.Serialize
import Extra.Serialize

data ProgramVersion =
  ProgramVersion
  { _gitCommit :: Text
  , _gitAuthorDate :: Text -- UTCTime
  -- ^ I was going to store this as UTCTime but some conversion issues
  -- arose in ghcjs.  This should be investigated.
  , _localChanges :: Text
  } deriving (Generic, Read, Show, Eq, Ord, Serialize)

instance SafeCopy ProgramVersion where version = 0
