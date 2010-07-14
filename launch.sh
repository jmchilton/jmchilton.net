#!/bin/sh

THE_CLASSPATH=
for i in `ls ./lib/*.jar`
do
  THE_CLASSPATH=${THE_CLASSPATH}:${i}
done

echo "Starting clojure with classpath $THE_CLASSPATH"
nohup java -XX:ReservedCodeCacheSize=24m -XX:MaxPermSize=35m -Xms150m -Xmx150m -cp "src:${THE_CLASSPATH}" clojure.main src/net/jmchilton/www/launch.clj &
tail -f nohup.out