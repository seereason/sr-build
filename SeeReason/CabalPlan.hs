{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}
{-# OPTIONS_GHC -fno-warn-type-defaults #-}

module SeeReason.CabalPlan where

import Cabal.Plan
import qualified Data.Map as M
import qualified Data.List as L
import Data.Typeable
-- import qualified Data.Text as T
import Data.Text (Text)
import qualified Data.Text as Text (pack)
import Shelly.Lifted as Sh (liftSh, run, run_, Sh, shelly)

default (Text)

isLocal :: Unit -> Bool
isLocal = utLocal . uType
  where utLocal ut = ut `elem` [UnitTypeLocal, UnitTypeInplace]

packageName :: Unit -> Text
packageName = name . uPId
  where name (PkgId (PkgName n) _) = n

compiler :: IO ()
compiler = readCabalPlan >>= (print . pjCompilerId)

exes :: Unit -> M.Map CompName CompInfo
exes = M.filterWithKey isExe . uComps

isExe :: CompName -> CompInfo -> Bool
isExe (CompNameExe _) _ = True
isExe _ _ = False

readCabalPlan = findAndDecodePlanJson (ProjectRelativeToDir ".")

linkPath :: Unit -> M.Map CompName CompInfo
linkPath = uComps

linkPath' :: CompInfo -> Maybe FilePath
linkPath' = ciBinFile

-- units are all the packages in the plan, including dependencies\

writeClientPlan :: PlanJson -> IO ()
writeClientPlan plan = do
  Just oldpath <- findProjectRoot "." :: IO (Maybe String)
  plan <- findAndDecodePlanJson (ProjectRelativeToDir ".")
  let compiler = (Text.pack . show) (pjCompilerId plan)
      newpath :: Text
      newpath = (Text.pack oldpath) <> "." <> compiler
      cp :: String -> Text -> Sh ()
      cp old new = run_ "cp" [Text.pack old, new]
  shelly (cp oldpath newpath)


test = do
  plan <- readCabalPlan
  let us = (M.filter isLocal (pjUnits plan))
  mapM_ (print . upp) (M.filter isLocal (pjUnits plan))
  mapM_ print (fmap pp $ M.toList . fmap M.toList $ M.filter (not . M.null) $  fmap exes (pjUnits plan))
    where pp :: (UnitId, [(CompName, CompInfo)]) -> (UnitId, [(CompName, Maybe FilePath)])
          pp (uid, cs) = (uid, fmap fmt cs)
          fmt (cname, cinfo) = (cname, linkPath' cinfo)
          upp :: Unit -> (UnitId, PkgId, Maybe Sha256)
          upp u = (uId u, uPId u, uSha256 u)

test0 = do
  plan <- readCabalPlan
  putStrLn "map (\\u -> (uId u, uPId u, uType u)) $ L.filter isLocal $ M.elems (pjUnits plan)"
  mapM_ print $ map (\u -> (uId u, uPId u, uType u)) $ L.filter isLocal $ M.elems (pjUnits plan)
  putStrLn "map (\\u -> (uComps u)) $ L.filter isLocal $ M.elems (pjUnits plan)"
  mapM_ print $ map (\u -> (uComps u)) $ L.filter isLocal $ M.elems (pjUnits plan)

  

