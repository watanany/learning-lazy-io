module LazyIO where

import Data.Aeson (FromJSON, Value, decodeStrict)
import RIO
import qualified RIO.Text as T
import Prelude (readFile)

-- | ファイル(@path@)から'LineItem'のリストを読み込む
readLineItems :: FilePath -> IO [Value]
readLineItems path = do
    content <- readFile path
    let items = map decodeJSONString (lines content)
    return (catMaybes items)

{- | ファイル(@path@)から'LineItem'のリストを読み込む
 デコードできない値があったら例外になる
-}
readLineItems' :: FilePath -> IO [Value]
readLineItems' path = do
    content <- readFile path
    let items = map decodeJSONString (lines content)
    if all isJust items
        then return (catMaybes items)
        else fail ("This file may include invalid record: " ++ path)

{- | decodeStrictの'String'版
 (ByteStringに毎回変換するのが面倒臭いので定義してある)
-}
decodeJSONString :: (FromJSON a) => String -> Maybe a
decodeJSONString = decodeStrict . encodeUtf8 . T.pack
