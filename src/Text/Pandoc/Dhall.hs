module Text.Pandoc.Dhall where

import Data.Either.Validation
import qualified Dhall as D
import Text.Pandoc
import Data.Text as T

-- | Decode a Pandoc value.
pandocDecoder :: (ReaderOptions -> Text -> PandocPure Pandoc) -> ReaderOptions -> D.InputNormalizer -> D.Decoder Pandoc
pandocDecoder f ropts opts =
      D.Decoder
            { D.extract = extractDoc
            , D.expected = expectedDoc
            }
      where
        docDecoder :: D.Decoder Text
        docDecoder = D.autoWith opts

        extractDoc expression =
          case D.extract docDecoder expression of
              Success x -> case runPure (f ropts x) of
                Left exception   -> D.extractError (T.pack $ show exception)
                Right path       -> Success path
              Failure e        -> Failure e

        expectedDoc = D.expected docDecoder
