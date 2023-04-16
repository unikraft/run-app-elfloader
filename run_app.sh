#!/bin/sh

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
    echo "test" > ../static-pie-apps/gzip/rootfs/test.txt
    sudo rm -f ../static-pie-apps/gzip/rootfs/test.txt.gz
    ./run.sh -r ../static-pie-apps/gzip/rootfs/ ../static-pie-apps/gzip/gzip test.txt
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
    echo "test" > ../dynamic-apps/gzip/test.txt
    sudo rm -f ../dynamic-apps/gzip/test.txt.gz
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

available_applications()
{
  grep -E "^run_.+\(\)\$" "$0" | sed 's/()//' | sed 's/run_//' | sort
}

print_available_apps()
{
  printf "Possible apps:\n%s" "$(available_applications | tr '\n' ' ' | fold -s)"
}

if test $# -ne 1; then
  echo "Usage: $0 <app>"
  print_available_apps
  echo 1>&2
  exit 1
fi

app="$1"

if available_applications | grep -x "$app" >/dev/null; then
  run_"$app"
else
  echo "Unknown app '$app', don't know how to run it" 1>&2
  print_available_apps
  exit 1
fi
