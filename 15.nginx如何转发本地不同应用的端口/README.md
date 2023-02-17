

## nginx如何转发本地不同应用的端口
要在 Nginx 中配置反向代理，将本地不同应用的端口转发到同一个端口上，您可以按照以下步骤操作：


在http块中添加一个新的server块，并在其中配置反向代理：

bash
Copy code
```shell

http {
    ...
    server {
        listen 80;
        server_name example.com;

        location /app1 {
            proxy_pass http://localhost:3000;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }

        location /app2 {
            proxy_pass http://localhost:4000;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }
    }
}
```
在这里，我们定义了一个监听端口80，域名为example.com的server块，并在其中定义了两个location块，分别用于转发不同应用的端口。例如，对于/app1路径，
Nginx 将请求转发到本地端口3000，对于/app2路径，Nginx 将请求转发到本地端口4000。proxy_set_header指令用于设置请求头。

保存并关闭文件。

测试 Nginx 配置是否正确：

Copy code
sudo nginx -t
如果测试通过，请重启 Nginx 服务：

Copy code
sudo service nginx restart
现在，您可以通过访问http://example.com/app1和http://example.com/app2，
访问本地不同应用的端口。请注意，如果您的应用程序依赖于 WebSocket 或长轮询连接等实时通信技术，您可能需要进行其他 Nginx 配置。
