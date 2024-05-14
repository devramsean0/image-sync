# LIB
Shared code between rust and node. This project is written in rust and compiled for node

# Building
```sh
cargo install nj-cli # Only needed once
nj-cli build
```
# Usage
Just import the local lib into the project in this monorepo.
## Rust
```toml
s_lib = { path = "../lib"}
```
## JS
```json
{
    "s_lib": "../lib"
}
```
