import Database.HDBC 
import Database.HDBC.Sqlite3
import System.Environment
import System.Directory
import System.Console.GetOpt
import Data.List
import Control.Monad
import qualified Configuration.Util as ConfigurationUtil
import qualified Configuration.Types as ConfigurationTypes
import qualified Data.Text

data MigrationCommandOption = CreateDatabase | UpgradeDatabase | DoNothing 
                            deriving (Eq, Show)

data MigrationOptions = CommandOption MigrationCommandOption | ConfigDir String
                      deriving (Eq, Show)

optionDescriptions = [Option [] ["createDatabase"] (NoArg $ CommandOption CreateDatabase) "create a new database", 
                      Option [] ["upgradeDatabase"] (NoArg $ CommandOption UpgradeDatabase) "upgrade the database",
                      Option [] ["configFile"] (ReqArg ConfigDir "config") "configuration file"
                      ] 

data MigrationCommand = MigrationCommand { migrationCommandOption :: MigrationCommandOption, configFile :: (Maybe String)  }
                      deriving (Eq, Show)

processParsedArgument migrationCommand parsedArgument =
  case parsedArgument of 
    CommandOption command -> migrationCommand { migrationCommandOption = command  }
    ConfigDir configDir -> migrationCommand {configFile = Just configDir }

migrationCommand parsedArguments = 
  foldl' processParsedArgument MigrationCommand{migrationCommandOption = DoNothing, configFile = Nothing} parsedArguments

main :: IO ()
main = do
     putStr "Migrating database\n"     
     args <- getArgs
     let (parsedArgs, nonOptions,  errors) = getOpt Permute optionDescriptions args
     let appCommand = migrationCommand parsedArgs
     configuration <- case appCommand of
       MigrationCommand { configFile = Just filename} -> ConfigurationUtil.readConfiguration filename
       _ -> return Nothing
     case (appCommand, configuration) of
       (MigrationCommand { migrationCommandOption = CreateDatabase}, Just config)  -> createDatabase config
       (MigrationCommand { migrationCommandOption = UpgradeDatabase}, Just config) -> migrateDatabase config
       _ -> printUsage          
     return ()
     
printUsage :: IO ()
printUsage = do
  putStrLn $ usageInfo "Usage" optionDescriptions
  
getConnection configuration = do
  putStrLn $ show $ configuration
  connectSqlite3 $ ("sandbox/"++) $ ConfigurationTypes.databaseFile $ configuration

sortedSqlFiles :: [String] -> [String]
sortedSqlFiles = sort . filter (isSuffixOf ".sql")

getSortedSqlFiles directory = do
  directoryContents <- getDirectoryContents directory
  return $ sortedSqlFiles directoryContents

createDatabase :: ConfigurationTypes.Configuration -> IO ()
createDatabase configuration = do
  putStrLn "Creating database"
  conn <- getConnection configuration
  
  let initializationScripts = "./databaseMigrations/databaseInitialization"  
  sortedScripts <- getSortedSqlFiles initializationScripts
  runScripts conn initializationScripts sortedScripts
  
  let migrationsInitializationScripts = "./databaseMigrations/migrationsInitialization"
  sortedMigrationsScripts <- getSortedSqlFiles migrationsInitializationScripts
  runScripts conn migrationsInitializationScripts sortedMigrationsScripts
  return ()

migrateDatabase :: ConfigurationTypes.Configuration -> IO ()
migrateDatabase configuration = do
  conn <- getConnection configuration
  let migrationsDirectory =  "./databaseMigrations/migrations"
  migrations <- getSortedSqlFiles migrationsDirectory
  runScripts conn migrationsDirectory migrations 
  return ()


runScripts conn rootDir fileNames = do
  forM fileNames (\ fileName -> do
                     let scriptPath = rootDir ++ "/" ++ fileName
                     putStrLn $ scriptPath
                     scriptData <- readFile scriptPath
                     runScript conn scriptData
                     return ()
                     )
  return ()
  
runScript conn script = do  
  putStrLn $ "Running "
  let strippedScript = Data.Text.unpack $ Data.Text.strip $ Data.Text.pack script
  putStrLn $ "|"++ strippedScript ++"|"
  case strippedScript of
    "" -> do
      putStrLn "No script"
      return ()
    _  -> withTransaction conn $ \connection -> runRaw connection script
  return ()