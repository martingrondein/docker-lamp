# Simple Docker LAMP/LEMP Stack

- Alpine based.
- Built using latest (yet stable) versions of PHP 8.1 FPM, Nginx, Node, Composer and MariaDB.
- Built using best practises (to my knowledge at the time).
- Nginx, MariaDB and PHP have been graciously optimized.
- Exposed and easy to tweak PHP-FPM and Nginx config variables.
- Neatly formatted, organised and commented Dockerfile.
- Also included are initial variables to easily swap out for new versions.

## 1. Setup

Ensure you have Docker installed and then run:

```sh
git clone https://github.com/martingrondein/docker-lamp.git
mv .env.sample .env
docker-compose up -d
```

## 2. Usage

Simply pop all your PHP application files in the `/app` folder and navigate to `http://localhost`. Remember Alpine uses `sh` rather than `bash`.

### Quickly get into the application/PHP container

```sh
docker-compose exec -it php sh
```

### Using Composer

```sh
 docker-compose exec -it php composer COMPOSER_COMMAND_GOES_HERE
 ```

### Using NPM

```sh
 docker-compose exec -it php npm NPM_COMMAND_GOES_HERE
 ```

### Using Node

```sh
 docker-compose exec -it php npm NODE_COMMAND_GOES_HERE
 ```

### Modify the Nginx config

```sh
nginx/default.conf
```

### Modify the PHP config

```sh
php/php.ini
```

### Modify the PHP-FPM config

```sh
php/www.conf
```

### Modify the MariaDB config

```sh
mysql/my.conf
```

## 3. FAQ

### Q: Why use Alpine over Ubuntu?

A: Alpine images are lightweight and have a smaller attack surfaces. When there’s not a lot of packages and libraries on your system, there’s very little that can go wrong. It comes with a lot less bloat and when it comes to using it in Docker, build times also seem faster.

Some articles to support this claim:

- [You Should Use Alpine Linux Instead of Ubuntu](https://hackernoon.com/you-should-use-alpine-linux-instead-of-ubuntu-yb193ujt)
- [The 3 Biggest Wins When Using Alpine as a Base Docker Image](https://nickjanetakis.com/blog/the-3-biggest-wins-when-using-alpine-as-a-base-docker-image)

### Q: Is this production ready?

A: Not yet tested in a production environment! But I believe with a few additional security tweaks, it's early good enough to go!
