module SeeReason.CabalPlan where

import Cabal.Plan
import qualified Data.Map as M
import qualified Data.List as L
-- import qualified Data.Text as T
import Data.Text (Text)


isLocal :: Unit -> Bool
isLocal = utLocal . uType
  where utLocal ut = ut `elem` [UnitTypeLocal, UnitTypeInplace]

packageName :: Unit -> Text
packageName = name . uPId
  where name (PkgId (PkgName n) _) = n

compiler :: IO ()
compiler = readPlan >>= (print . pjCompilerId)


readPlan = findAndDecodePlanJson (ProjectRelativeToDir ".")

test = do
  plan <- readPlan
  putStrLn "map (\\u -> (uId u, uPId u, uType u)) $ L.filter isLocal $ M.elems (pjUnits plan)"
  mapM_ print $ map (\u -> (uId u, uPId u, uType u)) $ L.filter isLocal $ M.elems (pjUnits plan)
  putStrLn "map (\\u -> (uComps u)) $ L.filter isLocal $ M.elems (pjUnits plan)"
  mapM_ print $ map (\u -> (uComps u)) $ L.filter isLocal $ M.elems (pjUnits plan)

  

