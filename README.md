# test-project
[![Continuous Integration](https://github.com/JakubSzuber/test-project/workflows/CI/badge.svg)](https://github.com/JakubSzuber/test-project/actions/workflows/integration.yml)
[![Continuous Delivery](https://github.com/JakubSzuber/test-project/workflows/CD/badge.svg)](https://github.com/JakubSzuber/test-project/actions/workflows/delivery.yml)


Project for testing purposes

XXXmoze przenies
<h1>Development setup</h1>

To dev work after cloning the repo use `docker compose -f docker-compose.dev.yml up -d --build` for the initial setup and fixing temporary errors, after executing this 
command you can just start coding (the changes will be applied after each save) and you will see the website on [localhost:80](http://localhost:80) or [localhost:3000](http://localhost:3000). 
In order to debug code in VSC make sure that you have [.vscode/launch.json](https://github.com/JakubSzuber/test-project/blob/main/.vscode/launch.json) from that project. 
Note that the initial start, compiling and automatic reload of the website's content can take a little more time than usual. If you encounter any problems with dev 
work try to restart the container, your whole Docker and eventually WSL2.

***Furthermore: a pull request with the prefix "dev_" is highly recommended.***

write something about which and how Gitops deployment models ware implemented (push-base and pull-based)

write something about which git branching strategy is used in this repo (probably feature branches and/or forking reporitory....)

create github kanban "Project" and write about it on readme

A pull request with prefix "dev_" is recommended to contribute to the repo.

TODO ogarnij todo z moich workflow'sow i z notatek

hello.!!!!!!!:)
