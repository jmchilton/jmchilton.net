







readFile :: String -> String
-- Can't be done, not referentially transparent




















readFile :: String -> IO String
length :: String -> Int

countChars file = length (readFile file) -- wrong!
-- length takes in String not IO String









readFile :: String -> IO String

countChars :: String -> Int
countChars file = 
  do { contents <- readFile file; --contents :: String
       length contents 
     }

-- still wrong, do must return an action







readFile :: String -> IO String

-- return :: a -> IO a
countChars :: String -> IO Int
countChars file =
  do { contents <- readFile file;
       return (length contents)
     }

-- Procedures like countChars must return IO action











writeFile :: String -> String -> IO ()

copyFile String -> String -> IO ()
copyFile f1 f2 = 
  do { contents <- readFile file;
       writeFile contents f2
     }







