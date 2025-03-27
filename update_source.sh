#!/usr/bin/env bash

set -euo pipefail

function switchBranch() {
    echo "--- Switching to oryx ---"
    git switch oryx
    echo ""
}

function updateBranch() {
    echo "Updating oryx"
    git pull origin oryx
    echo ""
}

function downloadSource() {
    echo "--- Downloading source ---"
    local -r voyagerSource="https://oryx.zsa.io/source/$1"
    curl -L "$voyagerSource" -o source.zip
    echo ""
}

function extractSource() {
    echo "--- Extracting source ---"
    unzip -oj source.zip '*_source/*' -d source
    rm source.zip
    echo ""
}

function updateSource() {
    echo "--- Updating 'orxy' branch ---"
    git add source
    if ! git commit -m "Update sources from Oryx"; then
        return
    fi
    git push origin oryx
    echo ""
}

function mergeBranch() {
    echo "--- Merging oryx into main ---"
    git switch main
    echo ""
    git pull origin main
    echo ""
    git merge -Xignore-all-space oryx
    echo ""
    echo "--- Update success full ---"
}

function main() {
    switchBranch
    downloadSource
    extractSource
    updateSource
    mergeBranch
}
main
