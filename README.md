# toboid.com

Blog site built with [Jekyll](http://jekyllrb.com/) and [Chalk](https://github.com/nielsenramon/chalk)

## Development
Build image:

``` bash
docker build --rm -t toboid.com .
```

Start a container at the command line:
``` bash
docker run --rm -i -t -p 4000:4000 -v "$PWD":/app --name toboid.com_c toboid.com /bin/bash
```

Run Jekyll:
``` bash
bundle exec jekyll serve --host 0.0.0.0
```

Run container as site:
``` bash
docker run --rm -i -t -p 4000:4000 -v "$PWD":/app --name toboid.com_c toboid.com bundle exec jekyll serve --host 0.0.0.0
```
or
``` bash
docker-compose up
```

## Deploy to GitHub Pages

Run this in the root project folder in your console:

    bin/deploy

You can find more info on how to use the gh-pages branch and a custom domain [here](https://help.github.com/articles/quick-start-setting-up-a-custom-domain/).

[View this](https://github.com/nielsenramon/kickster#automated-deployment-with-circle-ci) for more info about automated deployment with Circle CI.
