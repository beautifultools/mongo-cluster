FROM mongo:5.0.1

WORKDIR /scripts

COPY . .

RUN chmod 400 ./security/*keyfile

CMD /bin/bash main.sh

