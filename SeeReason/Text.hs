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

#if 1
diffText = undefined
#else  
-- | Output the difference between two string in the style of diff(1).  This
-- can be used with Test.HUnit.assertString:  assertString (diffText ("a", "1\n2\n3\n"), ("b", "1\n3\n"))
diffText :: (String, Text) -> (String, Text) -> String
diffText (nameA, textA) (nameB, textB) = return "diffText isn't here right now"

    -- show (prettyContextDiff
    --       (HPJ.text nameA)
    --       (HPJ.text nameB)
    --       (HPJ.text . unpack)
    --       (getContextDiff 2 (split (== '\n') textA) (split (== '\n') textB)))
#endif
