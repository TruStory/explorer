FROM node:10 as build
RUN curl https://install.meteor.com/ | sh
COPY big_dipper /build/big_dipper
WORKDIR /build/big_dipper
RUN export METEOR_ALLOW_SUPERUSER=true && meteor --allow-superuser npm install && ./build.sh
RUN ls -ltrah /build

FROM node:10 as final
ENV METEOR_SETTINGS_FILE=/config/settings.json
ENV ROOT_URL=https://explorer.testnet.trustory.io
RUN mkdir -p /opt/big_dipper
COPY settings.json /config/settings.json
COPY --from=build /build/output/big_dipper.tar.gz /opt/big_dipper/big_dipper.tar.gz
RUN cd /opt/big_dipper && tar -xvzf big_dipper.tar.gz
ADD ./start.sh /opt/big_dipper
WORKDIR /opt/big_dipper
RUN cd /opt/big_dipper/bundle/programs/server && \ 
    npm install --production
ENTRYPOINT [ "bash", "/opt/big_dipper/start.sh" ]
