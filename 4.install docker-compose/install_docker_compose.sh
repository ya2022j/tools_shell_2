//安装docker-compose(已安装者忽略)
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod  +x /usr/local/bin/docker-compose
//查询是否安装成功

docker-compose -v 
