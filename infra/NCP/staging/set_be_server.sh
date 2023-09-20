#!/bin/sh

# 1. docker login
docker login likelion-cr-jh.kr.ncr.ntruss.com \
    -u "CAD81F2227E0D002F8AF" \
    -p "57AE03744B2BACBC05E2072D83E4B385282379E9" 

# 2. docker pull
docker pull likelion-cr-jh.kr.ncr.ntruss.com/tee2:latest

# 3. 환경파일은 만들어 놨음


# 4. docker run
docker run -p 8000:8000 -d \
    --name tee2 \
    -v ~/.aws:/root/.aws:ro \
    --env-file .env \
    likelion-cr-jh.kr.ncr.ntruss.com/tee2:latest