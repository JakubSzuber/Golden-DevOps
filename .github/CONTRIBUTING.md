<h1>Development setup</h1>

To dev work after cloning the repo use `docker compose -f docker-compose.dev.yml up -d --build` for the initial setup and fixing temporary errors, after executing this 
command you can just start coding (the changes will be applied after each save) and you will see the website on [localhost:80](http://localhost:80) or [localhost:3000](http://localhost:3000). 
In order to debug code in VSC make sure that you have [.vscode/launch.json](https://github.com/JakubSzuber/Golden-DevOps/blob/main/.vscode/launch.json) from that project. 
Note that the initial start, compiling and automatic reload of the website's content can take a little more time than usual. If you encounter any problems with dev 
work try to restart the container, your whole Docker and eventually WSL2.

***Furthermore: a pull request with the prefix "dev_" is highly recommended.***
