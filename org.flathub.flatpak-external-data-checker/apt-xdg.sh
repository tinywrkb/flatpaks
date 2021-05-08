#!/bin/sh

apt \
  --option=Dir::Cache=$XDG_CACHE_HOME/apt \
  --option=Dir::State=$XDG_DATA_HOME/apt \
  --option=Dir::State::status=$XDG_DATA_HOME/dpkg/status \
  --option=Dir::Etc::SourceList=$XDG_CONFIG_HOME/apt/sources.list \
  --option=Dir::Etc::Trusted=$XDG_CONFIG_HOME/apt/trusted.gpg \
  --option=Dir::Etc::TrustedParts=$XDG_CONFIG_HOME/apt/trusted.gpg.d \
  "$@"
