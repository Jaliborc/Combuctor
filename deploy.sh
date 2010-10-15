#!/bin/sh

rm -rf "${WOW_ADDON_DIR}Combuctor"
rm -rf "${WOW_ADDON_DIR}Combuctor_Config"
rm -rf "${WOW_ADDON_DIR}Combuctor_Sets"

cp -r Combuctor "${WOW_ADDON_DIR}"
cp -r Combuctor_Config "${WOW_ADDON_DIR}"
cp -r Combuctor_Sets "${WOW_ADDON_DIR}"

cp LICENSE "${WOW_ADDON_DIR}Combuctor"
cp LICENSE "${WOW_ADDON_DIR}Combuctor_Config"
cp LICENSE "${WOW_ADDON_DIR}Combuctor_Sets"

cp README.textile  "${WOW_ADDON_DIR}Combuctor"