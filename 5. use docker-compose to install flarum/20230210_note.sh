
deploy ---> ok

structure


localhost :: /home/flarum » pwd         
/home/flarum
localhost :: /home/flarum » tree
.
├── docker-compose.yml
└── flarum
    └── flarum.env










flarum.env

===>


DEBUG=true
FORUM_URL=http://127.0.0.1:8000


DB_HOST=mariadb
DB_NAME=flarum
DB_USER=flarum
DB_PASS=123456
DB_PREF=flarum_
DB_PORT=13306








docker-compose.yml
===>

version: "3"
 
services:
  flarum:
    image: mondedie/flarum:stable
    container_name: flarum
    env_file:
      - /home/flarum/flarum/flarum.env   # 创建一个flarum.env,注意下一步建立的文件目录
    volumes:   # 数据映射到本地，数据不会因为Docker停止而丢失
      - /home/flarum/flarum/assets:/flarum/app/public/assets
      - /home/flarum/flarum/extensions:/flarum/app/extensions
      - /home/flarum/flarum/storage/logs:/flarum/app/storage/logs
      - /home/flarum/flarum/nginx:/etc/nginx/flarum
    ports:
      - 8000:8888   # 左边的8080可以自己调整端口号，右边的8888不要改

    depends_on:
      - mariadb
 
  mariadb:
    image: mariadb:10.5
    container_name: mariadb
    environment:
      - MYSQL_ROOT_PASSWORD=123456
      - MYSQL_DATABASE=flarum
      - MYSQL_USER=flarum
      - MYSQL_PASSWORD=123456
    volumes:
      - /home/flarum/docker/mysql/db:/var/lib/mysql  # 数据映射到本地，数据不会因为Docker停止而丢失
    ports:
      - 13306:13306

