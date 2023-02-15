

## [Linux CentOS7 备份及还原系统](https://blog.csdn.net/CQAAK/article/details/125907232)
一、备份
使用root用户切换到 / 目录

```shell
su - root
cd /
```
然后使用下面的命令备份完整的系统：

```shell
tar cvpzf backup.tgz /  --exclude=/proc --exclude=/lost+found  --exclude=/backup.tgz --exclude=/mnt  --exclude=/sys
```
“tar”当然就是我们备份系统所使用的程序了。
“cvpfz”是tar的选项，意思是“创建档案文件”、“保持权限”(保留所有东西原来的权限)、“使用gzip来减小文件尺寸”。
“backup.gz”是我们将要得到的档案文件的文件名。
“/”是我们要备份的目录，在这里是整个文件系统。但是有几点需要注意：


```shell

backup.tgz
src_path
dst_path
scp root@dst_ip:src_path/backup.tgz 
scp root@192.168.56.140:/backup.tgz  /
```




不能备份以下几个文件（目录）

1. 当前压缩文件

2. /proc

3. /lost+found

4. /mnt

5. /sys

6. /media

在 档案文件名“backup.gz”和要备份的目录名“/”之间给出了备份时必须排除在外的目录。有些目录是无用的，例如“/proc”、“/lost+ found”、“/sys”。当然，“backup.gz”这个档案文件本身必须排除在外，否则你可能会得到一些超出常理的结果。如果不把“/mnt”排 除在外，那么挂载在“/mnt”上的其它分区也会被备份。另外需要确认一下“/media”上没有挂载任何东西(例如光盘、移动硬盘)，如果有挂载东西， 必须把“/media”也排除在外。如果你之前已经在这几个目录中放置了文件或数据还未取出，强烈建议另行备份。

然后在/目录下就多出来一个刚刚压缩好的tar包，可以自行拉出物理机，放在存储介质中。



 到此备份系统步骤就告一段落了，接下来是还原备份的tar包中所有系统配置文件。

二、还原
还原前应该知道的：

警告：这会把你分区里所有文件替换成压缩文档里的文件！

确保在你做其他任何事情之前，重新查看你备份所剔除的目录！

在 档案文件名“backup.gz”和要备份的目录名“/”之间给出了备份时必须排除在外的目录。有些目录是无用的，例如“/proc”、“/lost+ found”、“/sys”，即我们那条备份命令中：

 --exclude=/proc --exclude=/lost+found  --exclude=/mnt  --exclude=/sys 这几个目录

如果你之前已经在这几个目录中放置了文件或数据还未取出，强烈建议另行备份。

如果你的系统不存在这几个目录了，建议是重新创建且必须创建：

```shell
mkdir /proc
mkdir /lost+found
mkdir /mnt
mkdir /sys
```
并确保这几个目录的权限是：（修改权限的命令这里就不再过多赘述，可自行百度）

* /proc 权限：文件所有者和群组都为root，权限为555
* /lost+found 权限：文件所有者和群组都为root，权限为700
* /mnt 权限：文件所有者和群组都为root，权限为755
* /sys 权限：文件所有者和群组都为root，权限为555

 

接下来可以正式开始还原工作了：

①如果是已经损坏的系统，需要迁移到新的机器上安装备份系统的话，首先需要保证安装的系统版本要与系统版本一致，否则无法成功还原。其次要确保还原后的UUID要与备份机器的一致。具体操作如下：

a）安装系统这里就跳过了，各位可以自行前往官网下载与源系统（即备份系统）对应的镜像安装上去即可。

b）将先前准备好的tar包放入根目录”/“中，然后进行还原命令：

```shell
cd /
tar xvpfz backup.tgz  -C /
restorecon -Rv /
```
c）先查看/etc/fstab中对应硬盘的UUID
```shell
 cat /etc/fstab
```


此处/etc/fstab中的配置应为前面还原后的源主机的配置信息表，而本身的/etc/fstab在还原的过程已经被替换了，所以此处的UUID与机器本身的UUID不相符，我们可以查看对应挂载/boot的UUID是否与此处的UUID一致：

先df -hT看一下对应挂载关系：
```shell
df -hT
```


由于系统使用的是xfs文件系统，我们可以使用xfs_admin查看一下它实际对应的UUID：

```shell
xfs_admin -u /dev/sda1
```

 可以发现与上面的/etc/fstab表中的并不符合，我们可以把对应的挂载点/boot卸载了先：

```shell
umount /boot
```
警告！umount之后不要马上重启！！否则整台机器就无法打开了！
 我们将/etc/fstab中的UUID复制出来，用命令将/dev/sda1的UUID修改成与表中一致的UUID
```shell
xfs_admin -u /dev/sda1
xfs_admin -U 06843f9a-db08-4235-bcd3-383ddee17e11 /dev/sda1
```

* 挂载
* mount /dev/sdb1 /root/newdisk
* mount  设备名称 挂载目录
* 卸载
* umount /dev/sdb1
* umount /root/newdisk
* umount 设备名称/挂载目录


这时我们再将/dev/sda1挂载上/boot上再重启，此时应该就恢复到与源系统一致的状态了。
```shell
mount /dev/sda1 /boot
```
②如果是系统还未损坏，可以正常操作，可以直接按照①中的b步骤进行操作：

 a）将先前准备好的tar包放入根目录”/“中，然后进行还原命令：

```shell
cd /
tar xvpfz backup.tgz  -C /
restorecon -Rv /
```
当你重启以后，所以的事情都会和你备份的时候一模一样。

但是需要注意，这所有的还原的配置只是文件级别的还原，所有的应用、服务，没有开启的仍需手动开启！






centos 网卡重启方法

Arlingtonroad

于 2021-06-29 11:26:30 发布

4887
 收藏 3
分类专栏： linux
版权

华为云开发者联盟
该内容已被华为云开发者联盟社区收录，社区免费抽大奖🎉，赢华为平板、Switch等好礼！
加入社区

linux
专栏收录该内容
34 篇文章1 订阅
订阅专栏
1、centos6的网卡重启方法：service network restart
centos7的网卡重启方法：systemctl restart network

2、centos重启网口方法：
关闭网卡口：ifdown eth0 或 ifconfig eth0 down
启动网卡口：ifup eth0 或 ifconfig eth0 up

3、配置网卡ip
增加ip：ifcfg eth0 add 192.168.1.251/24
删除ip：ifcfg eth0 del 192.168.1.251/24  或 ifcfg eth0 stop

使用快照恢复后系统后，启动网卡，可以上外网。

ifup ens33 
但是ssh连接还是有问题
没有/etc/init.d文件

.....
