{-# LANGUAGE DeriveAnyClass, DeriveLift, DeriveGeneric, OverloadedStrings, StandaloneDeriving, TemplateHaskell, UndecidableInstances #-}

module SeeReason.ProgramVersion
  ( ProgramVersion(..)
  , programVersion
  ) where

-- import Base.IsBlank (maybeFromBlank)
import Control.Exception as E (throw, try, IOException)
import Data.ByteString.Lazy as BS (fromStrict)
import Data.Digest.Pure.MD5 (md5)
import Data.SafeCopy (version)
import Data.Text (Text)
import qualified Data.Text as Text (take)
import GHC.Generics
import SeeReason.ProgramVersion

#if LOCAL_BUILD
#if CLIENT
import Data.Text (pack)
#else
#endif
#endif

#if !__GHCJS__
import Data.List (drop, splitAt)
import Data.SafeCopy
import Data.Serialize
import Language.Haskell.TH.Lift
import Extra.Serialize
import Safe
import Text.Read (readMaybe)
import System.IO.Error (isDoesNotExistError)

#endif


#if !__GHCJS__
deriving instance Lift ProgramVersion
#endif

-- | Collect and compute the specifications for this build.  This
-- works for local builds because it makes an assumption about where
-- to find the nix-seereason repo and the availability of the git
-- command.
programVersion :: IO ProgramVersion
programVersion = do
#if LOCAL_BUILD
#if CLIENT
  -- Compute the git commit of the current directory, presumably happstack-ghcjs.
  -- This is called from ClientMain.hs
  v@(ProgramVersion c t _) <- do
    read <$> readCreateProcess (proc "git" ["log", "-1",
                                            "--pretty=format:ProgramVersion {_gitCommit=\"%H\", _gitAuthorDate=\"%ai\", _localChanges=\"\"}"]) ""
  diff <- readCreateProcess (proc "git" ["diff", "--", "."]) ""
  let v' = v {_localChanges = pack diff}
  writeFile "nix-version" (show v')
  pure v'
#else
  -- For the local server build we use the nix-version written by the
  -- client.  This avoids differences due to edits that occurred while
  -- the server was building.
  (r :: Either IOException ProgramVersion) <-
    try $ do
     t <- readFile "nix-version"
     case readMaybe t of
       Just v -> return v
       Nothing -> noParse t
  either compute return r
#endif
#else
  (r :: Either IOException ProgramVersion) <-
    try $ do
     -- For the nix build this file was written from seereason-private.nix.
     t <- readFile "nix-version"
     case readMaybe t of
       Just v -> return v
       Nothing -> noParse t
  either compute return r
#endif
  where
    compute :: IOException -> IO ProgramVersion
    compute e | isDoesNotExistError e = error "nix-version file does not exist"
    compute e = throw e
    noParse t = error $ "readFile \"nix-version\" >>= \t -> read (" <> show t <> " :: ProgramVersion)"
