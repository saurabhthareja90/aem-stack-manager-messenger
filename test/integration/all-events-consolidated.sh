#!/usr/bin/env bash

set -o errexit

STACK_PREFIX="$1"
TARGET_AEM_STACK_PREFIX="$2"

CONFIG_PATH=examples/user-config/

AEM_PACKAGE_GROUP=shinesolutions
AEM_PACKAGE_NAME=aem-helloworld-content
AEM_PACKAGE_VERSION=0.0.1
AEM_PACKAGE_URL="http://central.maven.org/maven2/com/$AEM_PACKAGE_GROUP/$AEM_PACKAGE_NAME/$AEM_PACKAGE_VERSION/$AEM_PACKAGE_NAME-$AEM_PACKAGE_VERSION.zip"

##################################################
# Check AEM Consolidated Architecture readiness
##################################################

make check-readiness-consolidated \
  stack_prefix="$STACK_PREFIX" \
  target_aem_stack_prefix="$TARGET_AEM_STACK_PREFIX" \
  config_path="$CONFIG_PATH"

# ##################################################
# # List packages on AEM Author and AEM Publish
# ##################################################

make list-packages \
  stack_prefix="$STACK_PREFIX" \
  target_aem_stack_prefix="$TARGET_AEM_STACK_PREFIX" \
  config_path="$CONFIG_PATH" \
  component=author-publish-dispatcher

##################################################
# Enable and disable CRXDE on AEM Author and AEM Publish
##################################################

make enable-crxde \
  stack_prefix="$STACK_PREFIX" \
  target_aem_stack_prefix="$TARGET_AEM_STACK_PREFIX" \
  config_path="$CONFIG_PATH" \
  component=author-publish-dispatcher

make disable-crxde \
  stack_prefix="$STACK_PREFIX" \
  target_aem_stack_prefix="$TARGET_AEM_STACK_PREFIX" \
  config_path="$CONFIG_PATH" \
  component=author-publish-dispatcher

##################################################
# Flush AEM Dispatcher cache
##################################################

make flush-dispatcher-cache \
  stack_prefix="$STACK_PREFIX" \
  target_aem_stack_prefix="$TARGET_AEM_STACK_PREFIX" \
  config_path="$CONFIG_PATH" \
  component=author-publish-dispatcher

##################################################
# Deploy a set of artifacts to AEM Full-Set Architecture
##################################################

make deploy-artifacts-consolidated \
  stack_prefix="$STACK_PREFIX" \
  target_aem_stack_prefix="$TARGET_AEM_STACK_PREFIX" \
  config_path="$CONFIG_PATH" \
  descriptor_file=deploy-artifacts-descriptor.json

make check-readiness-consolidated \
  stack_prefix="$STACK_PREFIX" \
  target_aem_stack_prefix="$TARGET_AEM_STACK_PREFIX" \
  config_path="$CONFIG_PATH"

##################################################
# Deploy a single AEM package to AEM Author
##################################################

make deploy-artifact \
  stack_prefix="$STACK_PREFIX" \
  target_aem_stack_prefix="$TARGET_AEM_STACK_PREFIX" \
  config_path="$CONFIG_PATH" \
  component=author-publish-dispatcher \
  aem_id=author \
  source="$AEM_PACKAGE_URL" \
  group="$AEM_PACKAGE_GROUP" \
  name="$AEM_PACKAGE_NAME" \
  version="$AEM_PACKAGE_VERSION" \
  replicate=true \
  activate=false \
  force=true

make check-readiness-consolidated \
  stack_prefix="$STACK_PREFIX" \
  target_aem_stack_prefix="$TARGET_AEM_STACK_PREFIX" \
  config_path="$CONFIG_PATH"

##################################################
# Deploy a single AEM package to AEM Publish
##################################################

make deploy-artifact \
  stack_prefix="$STACK_PREFIX" \
  target_aem_stack_prefix="$TARGET_AEM_STACK_PREFIX" \
  config_path="$CONFIG_PATH" \
  component=author-publish-dispatcher \
  aem_id=publish \
  source="$AEM_PACKAGE_URL" \
  group="$AEM_PACKAGE_GROUP" \
  name="$AEM_PACKAGE_NAME" \
  version="$AEM_PACKAGE_VERSION" \
  replicate=false \
  activate=false \
  force=true

make check-readiness-consolidated \
  stack_prefix="$STACK_PREFIX" \
  target_aem_stack_prefix="$TARGET_AEM_STACK_PREFIX" \
  config_path="$CONFIG_PATH"

##################################################
# Schedule jobs for offline-snapshot
##################################################

make schedule-offline-snapshot-consolidated \
  stack_prefix="$STACK_PREFIX" \
  target_aem_stack_prefix="$TARGET_AEM_STACK_PREFIX" \
  config_path="$CONFIG_PATH"

##################################################
# Unschedule jobs for offline-snapshot
##################################################

make unschedule-offline-snapshot-consolidated \
  stack_prefix="$STACK_PREFIX" \
  target_aem_stack_prefix="$TARGET_AEM_STACK_PREFIX" \
  config_path="$CONFIG_PATH"

##################################################
# Schedule jobs for offline-compaction-snapshot
##################################################

make schedule-offline-compaction-snapshot-consolidated \
  stack_prefix="$STACK_PREFIX" \
  target_aem_stack_prefix="$TARGET_AEM_STACK_PREFIX" \
  config_path="$CONFIG_PATH"

##################################################
# Unschedule jobs for offline-compaction-snapshot
##################################################

make unschedule-offline-compaction-snapshot-consolidated \
  stack_prefix="$STACK_PREFIX" \
  target_aem_stack_prefix="$TARGET_AEM_STACK_PREFIX" \
  config_path="$CONFIG_PATH"

##################################################
# Take live snapshot of AEM Author and AEM Publish repositories
##################################################

make live-snapshot \
  stack_prefix="$STACK_PREFIX" \
  target_aem_stack_prefix="$TARGET_AEM_STACK_PREFIX" \
  config_path="$CONFIG_PATH" \
  component=author-publish-dispatcher

make check-readiness-consolidated \
  stack_prefix="$STACK_PREFIX" \
  target_aem_stack_prefix="$TARGET_AEM_STACK_PREFIX" \
  config_path="$CONFIG_PATH"
