# tracker部署

```shell
docker run -d --name fastdfs-tracker --net=host -e "FASTDFS_MODE=tracker" -e "FASTDFS_BASE_PATH=/fastdfs/tracker" -v /data/fastdfs/tracker:/fastdfs/tracker -p 22122:22122 fastdfs
```

变量：

| 参数              | 值说明               |
| ----------------- | -------------------- |
| FASTDFS_MODE      | tracker，启动tracker |
| FASTDFS_BASE_PATH | tracker存储路径      |

# storage部署

```shell
docker run -d --name fastdfs-storage --net=host -e "FASTDFS_MODE=storage" -e "FASTDFS_BASE_PATH=/fastdfs/storage" -e "FASTDFS_TRACKER_SERVER_NUM=2" -e "FASTDFS_GROUP_NAME=group1" -e "FASTDFS_TRACKER_SERVER_1=127.0.0.1" -e "FASTDFS_TRACKER_SERVER_2=127.0.0.1"  -e "FASTDFS_STORAGE_PORT=23000" -e "FASTDFS_STORAGE_HTTP_PORT=8888" -v /data/fastdfs/group1/storage:/fastdfs/storage -p 8888:8888 -p 23000:23000 fastdfs
```

变量：

| 参数                       | 值说明                                |
| -------------------------- | ------------------------------------- |
| FASTDFS_MODE               | storage，启动storage和nginx           |
| FASTDFS_TRACKER_SERVER_NUM | tracker节点个数                       |
| FASTDFS_TRACKER_SERVER_1   | tracker节点名字，后面的数据与个数对应 |
| FASTDFS_GROUP_NAME         | fastdfs组名                           |
| FASTDFS_BASE_PATH          | storage存储路径                       |
| FASTDFS_STORAGE_PORT       | storage的server端口号                 |
| FASTDFS_STORAGE_HTTP_PORT  | storage与nginx对应服务的端口号        |

# 访问方式

正常图片：

```http
http://127.0.0.1:8888/group1/M00/00/00/rBIAA1w4WlmEHJ5zAAAAABEZkYo781.png
```

缩略图片：

```http
http://127.0.0.1:8888/group1/M00/00/00/rBIAA1w4WlmEHJ5zAAAAABEZkYo781_200x200.png
```

文件：

```http
http://127.0.0.1:8888/group1/M00/00/00/rBIAA1w4ci-EPmxOAAAAAH644DY0437.gz
```


