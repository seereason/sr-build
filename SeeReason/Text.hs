{-# language CPP #-}
module SeeReason.Text
    ( diffText
    ) where

import Data.Algorithm.DiffContext (getContextDiff, prettyContextDiff)
--import Data.Char (isUpper, toUpper)
--import Data.ListLike (groupBy)
--import Data.String (IsString)
import Data.Text (split, Text, unpack)
--import qualified Data.Text.Lazy as Lazy ( fromStrict, pack, Text, toStrict, unpack )
import qualified Text.PrettyPrint as HPJ

diffText a b = return "diffText isn't here right now"

--diffText :: (String, Text) -> (String, Text) -> String
--diffText (nameA, textA) (nameB, textB) = return "diffText isn't here right now"
    -- show (prettyContextDiff
    --       (HPJ.text nameA)
    --       (HPJ.text nameB)
    --       (HPJ.text . unpack)
    --       (getContextDiff 2 (split (== '\n') textA) (split (== '\n') textB)))
