FROM dart:3.4.0

WORKDIR /app

ADD . /app/

RUN dart pub get
RUN dart pub global activate conduit 5.1.1
RUN dart pub run conduit db generate
RUN dart pub run conduit db validate
EXPOSE 6200

ENTRYPOINT ["dart", "pub", "run", "conduit:conduit", "serve", "--port", "6200"]