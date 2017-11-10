#!/bin/bash

# uninstall
echo "Removing action"
bx wsk action delete esbridge/onchange

echo "Removing package"
bx wsk package delete esbridge

echo "Removing rule"
bx wsk rule delete esbridgeRule --disable

echo "Removing Trigger"
bx wsk trigger delete esbridgeTrigger