#!/bin/sh

THE_CLASSPATH=
for i in `ls ./lib/*.jar`
do
  THE_CLASSPATH=${THE_CLASSPATH}:${i}
done

nohup java -Xmx128m -cp "src:${THE_CLASSPATH}" clojure.main src/net/jmchilton/www/launch.clj &