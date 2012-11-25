{-# LANGUAGE DeriveGeneric #-}

module Configuration.Types where

import GHC.Generics (Generic)
import Data.Aeson (FromJSON, ToJSON, decode, encode)


data Configuration = Configuration { databaseFile :: String }
    deriving (Show, Generic)

instance ToJSON Configuration

instance FromJSON Configuration






