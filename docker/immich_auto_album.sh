#!/usr/bin/env sh

# parse comma separated root paths and wrap in quotes
oldIFS=$IFS
IFS=','
# disable globbing
set -f          
# parse ROOT_PATH CSV
main_root_path=""
additional_root_paths=""
for path in ${ROOT_PATH}; do
  if [ -z "$main_root_path" ]; then
    main_root_path="\"$path\""
  else
    additional_root_paths="--root-path \"$path\" $additional_root_paths"
  fi
done
IFS=$oldIFS

# parse semicolon separated root paths and wrap in quotes
oldIFS=$IFS
IFS=':'
# parse  SHARE_WITH CSV
share_with_list=""
if [ ! -z "$SHARE_WITH" ]; then
    for share_user in ${SHARE_WITH}; do
        share_with_list="--share-with \"$share_user\" $share_with_list"
    done
fi

# parse PATH_FILTER CSV
path_filter_list=""
if [ ! -z "$PATH_FILTER" ]; then
    for path_filter_entry in ${PATH_FILTER}; do
        path_filter_list="--path-filter \"$path_filter_entry\" $path_filter_list"
    done
fi

# parse IGNORE CSV
ignore_list=""
if [ ! -z "$IGNORE" ]; then
    for ignore_entry in ${IGNORE}; do
        ignore_list="--ignore \"$ignore_entry\" $ignore_list"
    done
fi

# reset IFS
IFS=$oldIFS

unattended=
if [ ! -z "$UNATTENDED" ]; then
    unattended="--unattended"
fi

args="$unattended $main_root_path $API_URL $API_KEY"

if [ ! -z "$additional_root_paths" ]; then
    args="$additional_root_paths $args"
fi

if [ ! -z "$ALBUM_LEVELS" ]; then
    args="--album-levels $ALBUM_LEVELS $args"
fi

if [ ! -z "$ALBUM_SEPARATOR" ]; then
    args="--album-separator \"$ALBUM_SEPARATOR\" $args"
fi

if [ ! -z "$FETCH_CHUNK_SIZE" ]; then
    args="--fetch-chunk-size $FETCH_CHUNK_SIZE $args"
fi

if [ ! -z "$CHUNK_SIZE" ]; then
    args="--chunk-size $CHUNK_SIZE $args"
fi

if [ ! -z "$LOG_LEVEL" ]; then
    args="--log-level $LOG_LEVEL $args"
fi

if [ "$INSECURE" = "true" ]; then
    args="--insecure $args"
fi

if [ ! -z "$ignore_list" ]; then
    args="$ignore_list $args"
fi

if [ ! -z "$MODE" ]; then
    args="--mode \"$MODE\" $args"
fi

if [ ! -z "$DELETE_CONFIRM" ]; then
    args="--delete-confirm $args"
fi

if [ ! -z "$share_with_list" ]; then
    args="$share_with_list $args"
fi

if [ ! -z "$SHARE_ROLE" ]; then
    args="--share-role $SHARE_ROLE $args"
fi

if [ ! -z "$SYNC_MODE" ]; then
    args="--sync-mode $SYNC_MODE $args"
fi

if [ ! -z "$ALBUM_ORDER" ]; then
    args="--album-order $ALBUM_ORDER $args"
fi

if [ ! -z "$FIND_ASSETS_IN_ALBUMS" ]; then
    args="--find-assets-in-albums $args"
fi

if [ ! -z "$FIND_ARCHIVED_ASSETS" ]; then
    args="--find-archived-assets $args"
fi

if [ ! -z "$path_filter_list" ]; then
    args="$path_filter_list $args"
fi

if [ ! -z "$SET_ALBUM_THUMBNAIL" ]; then
    args="--set-album-thumbnail \"$SET_ALBUM_THUMBNAIL\" $args"
fi

if [ ! -z "$ARCHIVE" ]; then
    args="--archive $args"
fi

BASEDIR=$(dirname "$0")
echo $args | xargs python3 -u $BASEDIR/immich_auto_album.py