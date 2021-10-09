---
title: 扩展管理工具composer
date: 2021-10-09 10:47:51
tags:
---

### 前言

作为最热门的php的扩展工具，`composer`在各个php框架基本都会用到，本文介绍一下实用常规操作。

### composer的作用

Composer是 PHP 用来管理依赖（dependency）关系的工具。你可以在自己的项目中声明所依赖的外部工具库（libraries），Composer 会帮你安装这些依赖的库文件。

### 基本操作

`composer install` 安装依赖包，当你下载一个项目后，这或许是你改做的第一件事。

`composer require/update` 更新依赖包，我更喜欢用composer require。

`composer remove` 卸载依赖包

### 指定版本

update则无法在命令行传入新的版本号，需要先手动在`composer.json`中指定**新的版本号**，然后执行更新命令。但require可以直接在命令行传入版本号，例如:

```
composer require hashids/hashids:2.0.0
```

升级

```
composer require hashids/hashids:3.0.0
```

降级

```
composer require hashids/hashids:2.0.4
```

### 符号

版本号范围大于/大于等于：`>1.2.3` ` >=1.2.3`

小于/小于等于：`<1.2.3` ` <=1.2.3`

确切的版本号：`1.2.3`

~1.2.3: `1.2.3 <= version < 1.3`

^1.2.3: `1.2.3 <= version < 2.0`

### 全局参数(常用)

- -v 表示正常输出。
- -vv 表示更详细的输出。
- -vvv 则是为了 debug。
- **--help (-h):** 显示帮助信息。

### 常见的坑

> **卡着不动**

因为某些特殊情况，老外的源特别慢，我们就得把源改为国内的。阿里某个云。

```
 composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/
```



> **添加-vvv选项**

这样就知道compose这个家伙到底啥情况了。

```
composer install -vvv
```



> 提示不符合composer.json需要的版本，例如>=php7，但实际<php7也能正常运行，所以忽略

这样就可以正常运行了

```
composer install --ignore-platform-reqs
```



> Warning from https://mirrors.aliyun.com/composer: Support for Composer 1 is deprecated and some packages will not be available. You should upgrade to Composer 2.

解决方法：
更新一下 composer 工具版本：

```
composer self-update
```

出现错误:

```
The "https://getcomposer.org/versions" file could not be downloaded: SSL operation failed with code 1.

解决文章：
https://stackoom.com/question/3t3EF
```

### 参考文章

[composer指定php,composer 更新指定的依赖包](https://blog.csdn.net/weixin_29525745/article/details/116037185)

[PHP扩展管理工具COMPOSER的坑、常见问题和解决方法](https://www.freesion.com/article/22651405122/)

[Composer设置忽略版本匹配的方法](http://www.thinkphp.cn/code/2430.html)

[Warning from https://mirrors.aliyun.com/composer: Support for Composer 1 is deprecated and some packages will not be available. You should upgrade to Composer 2.](https://www.cnblogs.com/aze999/p/15062222.html)



## 后续

如果后面有空的话，也可能继续写一篇创建自己的composer包。
