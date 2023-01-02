#!/usr/bin/env bash
set -o errexit

kube-linter lint ./apps
