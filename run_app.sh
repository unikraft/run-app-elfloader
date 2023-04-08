#!/bin/bash

run_helloworld()
{
    ./run.sh -r rootfs/ ../static-pie-apps/lang/c/helloworld
}

run_helloworld_go()
{
    ./run.sh -r rootfs/ ../static-pie-apps/lang/go/helloworld
}

run_helloworld_cpp()
{
    ./run.sh -r rootfs/ ../static-pie-apps/lang/c++/helloworld
}

run_helloworld_rust_musl()
{
    ./run.sh -r rootfs/ ../static-pie-apps/lang/rust/helloworld-musl
}

run_helloworld_rust_gnu()
{
    ./run.sh -r rootfs/ ../static-pie-apps/lang/rust/helloworld-gnu
}

run_nginx()
{
    ./run.sh -n -r ../static-pie-apps/nginx/rootfs ../static-pie-apps/nginx/nginx
}

run_redis()
{
    ./run.sh -n -r ../static-pie-apps/redis/rootfs ../static-pie-apps/redis/redis-server /redis.conf
}

run_sqlite3()
{
    ./run.sh -r ../static-pie-apps/sqlite3/rootfs ../static-pie-apps/sqlite3/sqlite3
}

run_bc()
{
    ./run.sh -r rootfs/ ../static-pie-apps/bc/bc
}

run_gzip()
{
    ./run.sh -r ../static-pie-apps/gzip/rootfs ../static-pie-apps/gzip/gzip /README.md
}

apps=("helloworld" "helloworld_go" "helloworld_cpp" "helloworld_rust_musl" "helloworld_rust_gnu" "nginx" "redis" "sqlite3" "bc" "gzip")

if test $# -ne 1; then
    echo "Usage: $0 <app>" 1>&2
    echo 1>&2
    echo "Possible apps: ${apps[@]}" 1>&2
    exit 1
fi

app="$1"

if [[ ! " ${apps[*]} " =~ " $app " ]]; then
    echo "Unknown app $app" 1>&2
    echo 1>&2
    echo "Possible apps: ${apps[@]}" 1>&2
    exit 1
fi

if test ! "$(type -t run_"$app")" = "function"; then
    echo "Don't know how to run $app" 1>&2
    exit 1
fi

run_"$app"
