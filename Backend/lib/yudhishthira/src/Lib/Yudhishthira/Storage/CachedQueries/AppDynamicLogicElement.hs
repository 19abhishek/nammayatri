{-# OPTIONS_GHC -Wno-dodgy-exports #-}
{-# OPTIONS_GHC -Wno-orphans #-}
{-# OPTIONS_GHC -Wno-unused-imports #-}

module Lib.Yudhishthira.Storage.CachedQueries.AppDynamicLogicElement where

import Kernel.Prelude
import qualified Kernel.Prelude
import qualified Kernel.Storage.Hedis as Hedis
import Kernel.Utils.Common
import qualified Lib.Yudhishthira.Storage.Beam.BeamFlow as BeamFlow
import qualified Lib.Yudhishthira.Storage.Queries.AppDynamicLogicElement as Queries
import qualified Lib.Yudhishthira.Types
import qualified Lib.Yudhishthira.Types.AppDynamicLogicElement

findByDomain :: (BeamFlow.BeamFlow m r) => (Lib.Yudhishthira.Types.LogicDomain -> m ([Lib.Yudhishthira.Types.AppDynamicLogicElement.AppDynamicLogicElement]))
findByDomain domain = do
  Hedis.withCrossAppRedis (Hedis.safeGet $ "yudhishthiraCachedQueries:AppDynamicLogicElement:" <> ":Domain-" <> show domain)
    >>= ( \case
            Just a -> pure a
            Nothing ->
              ( \dataToBeCached -> do
                  expTime <- fromIntegral <$> asks (.cacheConfig.configsExpTime)
                  Hedis.withCrossAppRedis $ Hedis.setExp ("yudhishthiraCachedQueries:AppDynamicLogicElement:" <> ":Domain-" <> show domain) dataToBeCached expTime
              )
                /=<< Queries.findByDomain domain
        )

findByDomainAndVersion ::
  (BeamFlow.BeamFlow m r) =>
  (Lib.Yudhishthira.Types.LogicDomain -> Kernel.Prelude.Int -> m ([Lib.Yudhishthira.Types.AppDynamicLogicElement.AppDynamicLogicElement]))
findByDomainAndVersion domain version = do
  Hedis.withCrossAppRedis (Hedis.safeGet $ "yudhishthiraCachedQueries:AppDynamicLogicElement:" <> ":Domain-" <> show domain <> ":Version-" <> show version)
    >>= ( \case
            Just a -> pure a
            Nothing ->
              ( \dataToBeCached -> do
                  expTime <- fromIntegral <$> asks (.cacheConfig.configsExpTime)
                  Hedis.withCrossAppRedis $ Hedis.setExp ("yudhishthiraCachedQueries:AppDynamicLogicElement:" <> ":Domain-" <> show domain <> ":Version-" <> show version) dataToBeCached expTime
              )
                /=<< Queries.findByDomainAndVersion Nothing Nothing domain version
        )

clearCache :: BeamFlow.BeamFlow m r => Lib.Yudhishthira.Types.LogicDomain -> m ()
clearCache domain =
  Hedis.withCrossAppRedis $ Hedis.del $ "yudhishthiraCachedQueries:AppDynamicLogicElement:" <> ":Domain-" <> show domain

createMany :: (BeamFlow.BeamFlow m r) => [Lib.Yudhishthira.Types.AppDynamicLogicElement.AppDynamicLogicElement] -> m ()
createMany = Queries.createMany