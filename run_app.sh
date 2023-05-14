#!/bin/sh

extra_args=""

run_helloworld_static()
{
    ./run.sh -r rootfs/ ../static-pie-apps/lang/c/helloworld
}

run_server_static()
{
    ./run.sh -n -r rootfs/ ../static-pie-apps/lang/c/server
}

run_client_static()
{
    ./run.sh -n -r rootfs/ ../static-pie-apps/lang/c/client 172.44.0.2 3333
}

run_helloworld_go_static()
{
    ./run.sh -r rootfs/ ../static-pie-apps/lang/go/helloworld
}

run_server_go_static()
{
    ./run.sh -n -r rootfs/ ../static-pie-apps/lang/go/server
}

run_client_go_static()
{
    ./run.sh -n -r rootfs/ ../static-pie-apps/lang/go/client 172.44.0.2 3333
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
    echo "test" > ../static-pie-apps/gzip/rootfs/test.txt
    sudo rm -f ../static-pie-apps/gzip/rootfs/test.txt.gz
    ./run.sh -r ../static-pie-apps/gzip/rootfs/ ../static-pie-apps/gzip/gzip test.txt
}

run_helloworld()
{
    ./run.sh -r ../dynamic-apps/lang/c/ "$extra_args" /helloworld
}

run_server()
{
    ./run.sh -n -r ../dynamic-apps/lang/c/ "$extra_args" /server
}

run_client()
{
    ./run.sh -n -r ../dynamic-apps/lang/c/ "$extra_args" /client 172.44.0.1 3333
}

run_helloworld_go()
{
    ./run.sh -r ../dynamic-apps/lang/go/ "$extra_args" /helloworld
}

run_server_go()
{
    ./run.sh -n -r ../dynamic-apps/lang/go/ "$extra_args" /server
}

run_client_go()
{
    ./run.sh -n -r ../dynamic-apps/lang/go/ "$extra_args" /client 172.44.0.1 3333
}

run_helloworld_cpp()
{
    ./run.sh -r ../dynamic-apps/lang/c++/ "$extra_args" /helloworld
}

run_helloworld_rust()
{
    ./run.sh -r ../dynamic-apps/lang/rust/ "$extra_args" /helloworld
}

run_bc()
{
    ./run.sh -r ../dynamic-apps/bc/ "$extra_args" /usr/bin/bc
}

run_gzip()
{
    echo "test" > ../dynamic-apps/gzip/test.txt
    sudo rm -f ../dynamic-apps/gzip/test.txt.gz
    ./run.sh -r ../dynamic-apps/gzip/ "$extra_args" /bin/gzip test.txt
}

run_sqlite3()
{
    ./run.sh -r ../dynamic-apps/sqlite3/ "$extra_args" /usr/bin/sqlite3
}

run_nginx()
{
    ./run.sh -n -r ../dynamic-apps/nginx/ "$extra_args" /usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf
}

run_redis()
{
    ./run.sh -n -r ../dynamic-apps/redis/ "$extra_args" /usr/bin/redis-server /etc/redis/redis.conf
}

run_redis7()
{
    ./run.sh -n -r ../dynamic-apps/redis7/ "$extra_args" /usr/bin/redis-server /etc/redis/redis.conf
}

run_python()
{
    ./run.sh -r ../dynamic-apps/lang/python/ "$extra_args" /bin/python3.11
}

run_openssl()
{
    ./run.sh -r ../dynamic-apps/openssl/ "$extra_args" /bin/openssl enc -aes-128-cbc -in /input.txt -out /input.enc -K 01020304050607080900010203040506 -iv 01020304050607080900010203040506
}

run_echo()
{
    ./run.sh -r ../dynamic-apps/echo/ "$extra_args" /bin/echo Hello
}

run_ls()
{
    ./run.sh -r ../dynamic-apps/ls/ "$extra_args" /bin/ls
}

run_haproxy()
{
    ./run.sh -n -r ../dynamic-apps/haproxy/ "$extra_args" /bin/haproxy -f /etc/haproxy/haproxy.conf
}

run_bzip2()
{
    echo "test" > ../dynamic-apps/bzip2/test.txt
    sudo rm -f ../dynamic-apps/bzip2/test.txt.bz2
    ./run.sh -r ../dynamic-apps/bzip2/ "$extra_args" /bin/bzip2 test.txt
}

available_applications()
{
    grep -E "^run_.+\(\)\$" "$0" | sed 's/()//' | sed 's/run_//' | sort
}

print_available_apps()
{
    printf "Possible apps:\n%s" "$(available_applications | tr '\n' ' ' | fold -s)"
}

if test $# -ne 1 -a $# -ne 2; then
    echo "Usage: $0 [-l] <app>"
    print_available_apps
    echo "    -l - use dynamic loader explicitly" 1>&2
    echo 1>&2
    exit 1
fi

if test "$1" = "-l"; then
    extra_args="/lib64/ld-linux-x86-64.so.2"
    shift
fi

app="$1"

if available_applications | grep -x "$app" >/dev/null; then
    run_"$app"
else
    echo "Unknown app '$app', don't know how to run it" 1>&2
    print_available_apps
    exit 1
fi
