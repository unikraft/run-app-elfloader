#!/bin/bash

run_helloworld_static()
{
    ./run.sh -r rootfs/ ../static-pie-apps/lang/c/helloworld
}

run_server_static()
{
    ./run.sh -n -r rootfs/ ../static-pie-apps/lang/c/server
}

run_helloworld_go_static()
{
    ./run.sh -r rootfs/ ../static-pie-apps/lang/go/helloworld
}

run_server_go_static()
{
    ./run.sh -n -r rootfs/ ../static-pie-apps/lang/go/server
}

run_helloworld_cpp_static()
{
    ./run.sh -r rootfs/ ../static-pie-apps/lang/c++/helloworld
}

run_helloworld_rust_static_musl()
{
    ./run.sh -r rootfs/ ../static-pie-apps/lang/rust/helloworld-musl
}

run_helloworld_rust_static_gnu()
{
    ./run.sh -r rootfs/ ../static-pie-apps/lang/rust/helloworld-gnu
}

run_nginx_static()
{
    ./run.sh -n -r ../static-pie-apps/nginx/rootfs ../static-pie-apps/nginx/nginx
}

run_redis_static()
{
    ./run.sh -n -r ../static-pie-apps/redis/rootfs ../static-pie-apps/redis/redis-server /redis.conf
}

run_sqlite3_static()
{
    ./run.sh -r ../static-pie-apps/sqlite3/rootfs ../static-pie-apps/sqlite3/sqlite3
}

run_bc_static()
{
    ./run.sh -r rootfs/ ../static-pie-apps/bc/bc
}

run_gzip_static()
{
    ./run.sh -r ../static-pie-apps/gzip/rootfs ../static-pie-apps/gzip/gzip /README.md
}

run_helloworld()
{
    ./run.sh -r ../dynamic-apps/lang/c/ /lib64/ld-linux-x86-64.so.2 /helloworld
}

run_server()
{
    ./run.sh -n -r ../dynamic-apps/lang/c/ /lib64/ld-linux-x86-64.so.2 /server
}

run_helloworld_go()
{
    ./run.sh -r ../dynamic-apps/lang/go/ /lib64/ld-linux-x86-64.so.2 /helloworld
}

run_server_go()
{
    ./run.sh -n -r ../dynamic-apps/lang/go/ /lib64/ld-linux-x86-64.so.2 /server
}

run_helloworld_cpp()
{
    ./run.sh -r ../dynamic-apps/lang/c++/ /lib64/ld-linux-x86-64.so.2 /helloworld
}

run_helloworld_rust()
{
    ./run.sh -r ../dynamic-apps/lang/rust/ /lib64/ld-linux-x86-64.so.2 /helloworld
}

run_bc()
{
    ./run.sh -r ../dynamic-apps/bc/ /lib64/ld-linux-x86-64.so.2 /usr/bin/bc
}

run_gzip()
{
    ./run.sh -r ../dynamic-apps/gzip/ /lib64/ld-linux-x86-64.so.2 /bin/gzip test.txt
}

run_sqlite3()
{
    ./run.sh -r ../dynamic-apps/sqlite3/ /lib64/ld-linux-x86-64.so.2 /usr/bin/sqlite3
}

run_nginx()
{
    ./run.sh -n -r ../dynamic-apps/nginx/ /lib64/ld-linux-x86-64.so.2 /usr/sbin/nginx
}

run_redis()
{
    ./run.sh -n -r ../dynamic-apps/redis/ /lib64/ld-linux-x86-64.so.2 /usr/bin/redis-server /etc/redis/redis.conf
}

apps=("helloworld_static" "server_static" "helloworld_go_static" "server_go_static" "helloworld_cpp_static" "helloworld_rust_static_musl" "helloworld_rust_static_gnu" "nginx_static" "redis_static" "sqlite3" "bc_static" "gzip_static")
apps+=("helloworld" "server" "helloworld_go" "server_go" "helloworld_cpp" "helloworld_rust" "nginx" "redis" "sqlite3" "bc" "gzip")
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
