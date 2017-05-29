---
published: true
layout: post
title: "Finding the node version of global modules installed through nvm"
description: "A handy function for finding which node versions globally installed modules are installed for when using nvm"
tags: [node]
---

If I want to know what node modules I have globally installed I use this command; it lists globally installed modules and their vesions.
```shell
npm ls -g --depth=0
```

However since I use [nvm](https://github.com/creationix/nvm) and work on many different projects with different node versions, I often
forget which node versions I have installed a global module for. nvm does let you copy global modules between versions but usually I just need to know the node version so I can switch to it and use the module. This function does just that; it lists which node versions (installed through nvm) the specified node module is globally installed for.

```shell
nvm_global () {
    PKG_NAME=$1
    VERSIONS=()

    I=0
    for VER in $(nvm_ls)
    do
        nvm exec --silent ${VER} npm ls -g ${PKG_NAME} --depth=0 >/dev/null 2>&1

        if [ $? -eq 0 ]; then
            VERSIONS[I]=${VER}
        fi

        let I=${I}+1
    done

    if [ ${#VERSIONS[@]} -eq 0 ]; then
        echo "${PKG_NAME} not found for any node version installed through nvm"
    else
        echo "Found ${PKG_NAME} for node versions:"
        for VERSION in "${VERSIONS[@]}"
        do
            echo -e "\t${VERSION}"
        done
    fi
}
```

Example usage:
```shell
nvm_global surge
```

Outputs
```
Found surge for versions:
    v6.9.1
```