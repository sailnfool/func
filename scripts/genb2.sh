#!/bin/bash
export HASHCNT=0
find . -type f -exec oneb2 {} ';'
