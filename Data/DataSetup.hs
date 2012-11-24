
import Database.HDBC 
import Database.HDBC.Sqlite3
import System.Environment

main :: IO ()
main = do
     args <- getArgs
     let databaseFile = head args
     print $ "Connecting to sqlite3 database :" ++ databaseFile
     conn <- connectSqlite3 "test1.db"
     tables <- getTables conn
     print tables
     withTransaction conn $ createTest tables
     disconnect conn

createTest tables conn =     
    if not $ elem "test" tables
         then do
                run conn "CREATE TABLE test (id INTEGER NOT NULL, desc VARCHAR(80))" []
                run conn "INSERT INTO test (id) VALUES (0)" []
                query <- quickQuery' conn "SELECT * from test where id < 2" []
                print query
                return ()
         else return ()
