
### 如何用docker安装node，npm，yarn，编译前端工程

* 要使用 Docker 安装 Node.js、npm 和 Yarn，并编译前端工程，可以按照以下步骤操作：

* 1. 创建一个新的 Dockerfile：

```shell
FROM node:14-alpine

WORKDIR /app

COPY package.json yarn.lock /app/

RUN yarn install

COPY . /app

RUN yarn build

```
在这里，我们使用 Node.js 14 的 Alpine 版本作为基础映像，将工作目录设置为/app，然后将package.json和yarn.lock文件复制到容器中，并运行yarn install安装依赖项。接下来，我们将应用程序的源代码复制到容器中，并运行yarn build编译前端工程。

* 2.在应用程序的根目录中创建一个.dockerignore文件，指定不需要复制到容器中的文件和目录，例如：

```shell
node_modules
.git
.dockerignore
Dockerfile

```

* 3.构建 Docker 映像：
```shell
docker build -t my-app .

```
在这里，my-app是您要构建的映像的名称。


* 4.运行容器：

```shell
docker run -p 8080:80 my-app

```

在这里，我们将容器的端口80映射到主机的端口8080，并指定要运行的映像名称为my-app。

现在，您可以在浏览器中打开http://localhost:8080，查看编译后的前端工程。

请注意，上述示例假定您的前端工程使用 Yarn 进行依赖管理和构建。如果您使用 npm 进行依赖管理，您可以将上述示例中的所有yarn命令替换为相应的npm命令，例如npm install和npm run build。
