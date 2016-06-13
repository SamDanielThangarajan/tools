#!/bin/bash

KEY=`cat ~/.ssh/id_rsa.pub`
./authorizeme.exp "127.0.0.1" "edansam" ${KEY}
