# redstoner.com

Redstoner's ruby-on-rails website with blog, forum, etc.

# Installation

You need a MySQL server with `utf8mb4` support.
If you have issues, try adding this to your `my.cnf`:
```
[mysqld]
character-set-client-handshake = FALSE
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci
```

The rest should be a default rails installation:
```shell
bundle
rake db:setup
rails s
```

Note: We currently use rails [4-2-stable](https://github.com/rails/rails/tree/4-2-stable) because it has backported [support for `utf8mb4`](https://github.com/rails/rails/commit/37e5770fd3db04f3206075d736fc14161dd04530).