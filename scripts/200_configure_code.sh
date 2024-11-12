#!/bin/sh
runuser user -c 'cat <<< $(jq '. += {"workbench.colorTheme": "Default Dark Modern"}' settings.json) > settings.json'