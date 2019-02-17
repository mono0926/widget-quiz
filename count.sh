#!/usr/bin/env bash
find ./lib -name "*.dart" | xargs cat | wc -c