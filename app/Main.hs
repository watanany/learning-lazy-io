module Main where

-- import Iteratees ()
import LazyIO (readLineItems)
import RIO
import RIO.List (lastMaybe)
import Prelude (getLine, print, putStrLn)

dataFile :: FilePath
dataFile = "./resource/data.jsonl"

mainWithLazyIO :: IO ()
mainWithLazyIO = do
    -- 動作確認の環境:
    -- - macOS: 12.2.1
    -- - GHC: 8.10.7
    --
    -- ファイルが開いているかどうかの確認方法:
    -- % watch -n 1 lsof dataFileのパス

    -- (1)
    items <- readLineItems dataFile
    putStrLn "評価前"
    -- この時点ではファイルはまだ開いている
    _ <- getLine

    -- (2)
    deepseq (take 1 items) $ return ()
    putStrLn "評価後(先頭1個)"
    -- この時点ではファイルはまだ開いている
    _ <- getLine

    -- (3)
    -- deepseqではなくseqだと、(4)の有無でファイルが閉じるタイミングが異なる
    -- - seqで(4)なし -> この時点でファイルが閉じている
    -- - seqで(4)あり -> この時点ではファイルはまだ開いている
    -- seq items $ return ()

    deepseq items $ return ()
    putStrLn "評価後"
    -- この時点でファイルは閉じている
    _ <- getLine

    -- (4)
    putStrLn "最後の行の値を表示"
    print $ lastMaybe items
    _ <- getLine

    return ()

mainWithIterateeIO :: IO ()
mainWithIterateeIO = undefined

main :: IO ()
main = do
    mainWithLazyIO
