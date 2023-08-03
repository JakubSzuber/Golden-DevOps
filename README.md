[![Continuous Integration](https://github.com/JakubSzuber/Golden-DevOps/workflows/CI/badge.svg)](https://github.com/JakubSzuber/Golden-DevOps/actions/workflows/integration.yml)
[![Continuous Delivery](https://github.com/JakubSzuber/Golden-DevOps/workflows/CD/badge.svg)](https://github.com/JakubSzuber/Golden-DevOps/actions/workflows/delivery.yml)
TODO Add above badges for other workflows

# Repository in progress, don't use yet!
<!-- TODO change above header to something similar to below -->
<!-- TODO here repo's main graphic -->
<!--
# Score-Counter-Game
***Description:*** A simple application focused on using many of Python's features mainly from standard library but also from the most basic modules. 
User in the game earns points for playing in four mini-games and at the end user can see its score and place at the leaderboard. Whole activity is saved into logs logs.txt file. The application has a GUI created in [CustomTkinter](https://github.com/TomSchimansky/CustomTkinter).
***Whole project and idea for it is totally my authorship!***
-->
Lorem ipsum dolor sit amet consectetur adipisicing elit. Maxime mollitia,
molestiae quas vel sint commodi repudiandae consequuntur voluptatum laborum
numquam blanditiis harum quisquam eius sed odit fugiat iusto fuga praesentium
optio, eaque rerum! Provident similique accusantium nemo autem. Veritatis
obcaecati tenetur iure eius earum ut molestias architecto voluptate aliquam
nihil, eveniet aliquid culpa officia aut! Impedit sit sunt quaerat, odit,
tenetur error, harum nesciunt ipsum debitis quas aliquid. Reprehenderit,
quia. Quo neque error repudiandae fuga? Ipsa laudantium molestias eos 
sapiente officiis modi at sunt excepturi expedita sint? Sed quibusdam
recusandae alias error harum maxime adipisci amet laborum.

<details>
<summary><b>Click to see the project structure:</b></summary>

```$ tree Golden-DevOps
.
├───.idea
│   └───...
├───.git
│   └───...
├─── docker-compose.yml
├─── docker-stack.yml
└─── ...
```
</details>

# Stack
<h3>Infrastructure:</h3>

- AWS <img align="center" alt="AWS" width="60px" src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/amazonwebservices/amazonwebservices-plain-wordmark.svg">
- Terraform <img align="center" alt="terraform" width="36px" src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/terraform/terraform-original.svg">
- Linux <img align="center" alt="linux" width="36px" src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/linux/linux-original.svg">

<h3>Deployment:</h3>

- Docker <img align="center" alt="docker" width="36px" src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/docker/docker-original.svg">
- Docker Compose <img align="center" alt="docker compose" width="36px" src="https://gitlab.developers.cam.ac.uk/uploads/-/system/project/avatar/4542/compose.png">
- Helm <img align="center" alt="Helm Charts" width="36px" src="https://helm.sh/img/helm.svg">
- Kubernetes <img align="center" alt="kubernetes" width="36px" src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/kubernetes/kubernetes-plain.svg">
- Argo CD <img align="center" alt="Argo CD" width="36px" src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/argocd/argocd-original.svg">
- GitHub Actions <img align="center" alt="github actions" width="36px" src="https://avatars.githubusercontent.com/u/54465427?v=4">

<h3>Application Logic:</h3>

- Nginx <img align="center" alt="Nginx" width="36px" src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/nginx/nginx-original.svg">
- React <img align="center" alt="React" width="36px" src="https://upload.wikimedia.org/wikipedia/commons/thumb/a/a7/React-icon.svg/2300px-React-icon.svg.png">

<h3>Configuration Management:</h3>

- Ansible <img align="center" alt="ansible" width="36px" src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/ansible/ansible-original.svg">

<!--TODO
<h3>Monitoring:</h3>

- Prometheus <img align="center" alt="prometheus" width="36px" src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/prometheus/prometheus-original.svg">
- Grafana <img align="center" alt="grafana" width="36px" src="https://github.com/devicons/devicon/blob/master/icons/grafana/grafana-original.svg">-->

# How to use the repo
> **Note**
> Example note...

If you don't have any internet domain then register one manually e.g. in the AWS console from Route 53 interface and create a hosted zone for in Route 53 (if you register a domain through Route 53 then the hosted zone is automatically created for that domain)
Create an ACM cert issued for yourdomain.com and *.yourdomain.com (you can do this e.g. in the AWS console from ACM 53 interface).
Create an S3 Bucket for a Terraform remote state.
XXSetup Terrafom infra
XXXAdd an alias record with the Ingress Load Balancer URL. AWS LoadBalancer Controller dynamically deploy a new LB or add new ingress into the same LB based on the setup.https://fewmorewords.com/eks-with-argocd-using-terraform#heading-5-post-deployment-stuff
XXXThen make sure you have right configured ~/.aws/credentials file on XXX so you have configured a default IAM user and IAM user that is used to access Argo CD (in this repo jakubszuber-admin). Both can be the same IAM user with the same AWS Access Key. MAYBE JUST OPENID SO THE BELOW LINE WON'T BE NEEDED.
Then Add your IAM user (eksadmin in my case) to the AWS configuration. Then update the kubeconfig to get access to your brand new EKS cluster and grab the ArgoCD default password from the argocd-initial-admin-secret.https://fewmorewords.com/eks-with-argocd-using-terraform#heading-5-post-deployment-stuff
export AWS_DEFAULT_PROFILE=jakubszuber-admin ALBO set AWS_DEFAULT_PROFILE=jakubszuber-admin
aws sts get-caller-identity
aws eks update-kubeconfig --name eks-demo --region us-east-1 --profile jakubszuber-admin
kubectl get secrets -n argocd
kubectl get secret argocd-initial-admin-secret -n argocd --template={{.data.password}} | base64 -d
Now you can log in as "admin" to argo.yourdomain.com


generate your own "cert.pem" and "key.pem" by command `openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 750 -nodes`. Then you can print them by `cat cert.pem | base64 -w 0` and `cat key.pem | base64 -w 0` so you are able to copy them from the terminal and insert as values to secret.yaml file that is in Helm chart. **Currently this method of using self-signed certificates is temporary and it would be better to use some other TLS certificate approach but if you are ok with then remember to not expose the values of "cert.pem" and "key.pem" in GitHub repo (this repo is showcase example and self-signed certificates will be removed in progress for this repo). Making the better and more secure approach is in progress for that repo!**
XXXDOCKERHUB_TOKEN, DOCKERHUB_USERNAME, SNYK_TOKEN, SLACK_WEBHOOK_URL, SLACK_WEBHOOK_URL2
Do https://github.com/marketplace/actions/slack-send#technique-3-slack-incoming-webhook
Change all occurrences of "jakubszuber/react-nginx-image" and "react-nginx-image" to your image
Setup OpenID Connect between GitHub and AWS
Configure Snyk account with repo
Create "Staging" and "Production" GitHub environments and then add a protection role for "Production" so this environment will require reviewers (add some reviews that will be able to allow for changes deployment)

> Note: By the way, if you use VSC then you probably want to have features (highlighting, recommendations, etc) for .tpl files the same as you probably already have for your YAML files. To do so in VSC open e.g. ingress.tpl and in the bottom-right corner click on "plain-text", then scroll down and click on "YAML" so from now you will have .tpl files associated with the YAML files (treated the same as YAML files), what can be very helpful!

Lorem ipsum dolor sit amet consectetur adipisicing elit. Maxime mollitia,
molestiae quas vel sint commodi repudiandae consequuntur voluptatum laborum
numquam blanditiis harum quisquam eius sed odit fugiat iusto fuga praesentium
optio, eaque rerum! Provident similique accusantium nemo autem. Veritatis
obcaecati tenetur iure eius earum ut molestias architecto voluptate aliquam
nihil, eveniet aliquid culpa officia aut! Impedit sit sunt quaerat, odit,
tenetur error, harum nesciunt ipsum debitis quas aliquid. Reprehenderit,
quia. Quo neque error repudiandae fuga? Ipsa laudantium molestias eos 
sapiente officiis modi at sunt excepturi expedita sint? Sed quibusdam
recusandae alias error harum maxime adipisci amet laborum.

<!--
<details>
<summary><b>Click to look at the demo process of deploying this app (example with Docker Compose):</b></summary>

https://user-images.githubusercontent.com/90647840/213922371-848ff6b3-60a8-4db2-94fb-7b11dbf41b42.mov
</details>
-->

# Requirements

XX AWS account, dockerhub account?, etc
Lorem ipsum dolor sit amet consectetur adipisicing elit. Maxime mollitia,
molestiae quas vel sint commodi repudiandae consequuntur voluptatum laborum.

# Reuired modifications

XXAdd right environment variables, secrets, dockerhub repository, etc
Lorem ipsum dolor sit amet consectetur adipisicing elit. Maxime mollitia,
molestiae quas vel sint commodi repudiandae consequuntur voluptatum laborum.

# Development setup

To dev work after cloning the repo use `docker compose -f docker-compose.dev.yml up -d --build` for the initial setup and fixing temporary errors, after executing this 
command you can just start coding (the changes will be applied after each save) and you will see the website on [localhost:80](http://localhost:80) or [localhost:3000](http://localhost:3000). 
In order to debug code in VSC make sure that you have [.vscode/launch.json](https://github.com/JakubSzuber/test-project/blob/main/.vscode/launch.json) from that project. 
Note that the initial start, compiling and automatic reload of the website's content can take a little more time than usual. If you encounter any problems with dev 
work try to restart the container, your whole Docker and eventually WSL2.

# Source code pipeline

Lorem ipsum dolor sit amet consectetur adipisicing elit. Maxime mollitia,
molestiae quas vel sint commodi repudiandae consequuntur voluptatum laborum
numquam blanditiis harum quisquam eius sed odit fugiat iusto fuga praesentium
optio, eaque rerum! Provident similique accusantium nemo autem. Veritatis
obcaecati tenetur iure eius earum ut molestias architecto voluptate aliquam
nihil, eveniet aliquid culpa officia aut! Impedit sit sunt quaerat, odit,
tenetur error, harum nesciunt ipsum debitis quas aliquid. Reprehenderit,
quia. Quo neque error repudiandae fuga? Ipsa laudantium molestias eos 
sapiente officiis modi at sunt excepturi expedita sint? Sed quibusdam
recusandae alias error harum maxime adipisci amet laborum.

# Terraform-related files pipeline

Lorem ipsum dolor sit amet consectetur adipisicing elit. Maxime mollitia,
molestiae quas vel sint commodi repudiandae consequuntur voluptatum laborum
numquam blanditiis harum quisquam eius sed odit fugiat iusto fuga praesentium
optio, eaque rerum! Provident similique accusantium nemo autem. Veritatis
obcaecati tenetur iure eius earum ut molestias architecto voluptate aliquam
nihil, eveniet aliquid culpa officia aut! Impedit sit sunt quaerat, odit,
tenetur error, harum nesciunt ipsum debitis quas aliquid. Reprehenderit,
quia. Quo neque error repudiandae fuga? Ipsa laudantium molestias eos 
sapiente officiis modi at sunt excepturi expedita sint? Sed quibusdam
recusandae alias error harum maxime adipisci amet laborum.

# Rolling back 

To roll back revert the right commit with a change and the GHA pipelines along with Argo CD will take care of...?
Lorem ipsum dolor sit amet consectetur adipisicing elit. Maxime mollitia,
molestiae quas vel sint commodi repudiandae consequuntur voluptatum laborum
numquam blanditiis harum quisquam eius sed odit fugiat iusto fuga praesentium
optio, eaque rerum! Provident similique accusantium nemo autem. Veritatis
obcaecati tenetur iure eius earum ut molestias architecto voluptate aliquam
nihil, eveniet aliquid culpa officia aut! Impedit sit sunt quaerat, odit,
tenetur error, harum nesciunt ipsum debitis quas aliquid. Reprehenderit,
quia. Quo neque error repudiandae fuga? Ipsa laudantium molestias eos 
sapiente officiis modi at sunt excepturi expedita sint? Sed quibusdam
recusandae alias error harum maxime adipisci amet laborum.

# Infrastructure

![](https://d2slcw3kip6qmk.cloudfront.net/marketing/blog/2019Q1/aws/aws-web-application-hosting.png)

Lorem ipsum dolor sit amet consectetur adipisicing elit. Maxime mollitia,
molestiae quas vel sint commodi repudiandae consequuntur voluptatum laborum
numquam blanditiis harum quisquam eius sed odit fugiat iusto fuga praesentium
optio, eaque rerum! Provident similique accusantium nemo autem. Veritatis
obcaecati tenetur iure eius earum ut molestias architecto voluptate aliquam
nihil, eveniet aliquid culpa officia aut! Impedit sit sunt quaerat, odit,
tenetur error, harum nesciunt ipsum debitis quas aliquid. Reprehenderit,
quia. Quo neque error repudiandae fuga? Ipsa laudantium molestias eos 
sapiente officiis modi at sunt excepturi expedita sint? Sed quibusdam
recusandae alias error harum maxime adipisci amet laborum.

# Clean up

Lorem ipsum dolor sit amet consectetur adipisicing elit. Maxime mollitia,
molestiae quas vel sint commodi repudiandae consequuntur voluptatum laborum
numquam blanditiis harum quisquam eius sed odit fugiat iusto fuga praesentium
optio, eaque rerum! Provident similique accusantium nemo autem. Veritatis
obcaecati tenetur iure eius earum ut molestias architecto voluptate aliquam
nihil, eveniet aliquid culpa officia aut! Impedit sit sunt quaerat, odit,
tenetur error, harum nesciunt ipsum debitis quas aliquid. Reprehenderit,
quia. Quo neque error repudiandae fuga? Ipsa laudantium molestias eos 
sapiente officiis modi at sunt excepturi expedita sint? Sed quibusdam
recusandae alias error harum maxime adipisci amet laborum.

## Contributing

Want to contribute to this project? Check out the
[contributing documentation](https://github.com/JakubSzuber/Golden-DevOps/blob/main/.github/CONTRIBUTING.md). Feel free to write on [Discussions](https://github.com/JakubSzuber/Golden-DevOps/discussions). You can also contact me on my Gmail [jszuber06@gmail.com](https://jszuber06@gmail.com).

If you find an issue, please report it on the
[issue tracker](https://github.com/JakubSzuber/Golden-DevOps/issues/new/choose).

## License and Authorship

This project uses [MIT License](https://github.com/JakubSzuber/Golden-DevOps/blob/main/LICENSE) and was entirely created by myself. If you want to publically use this repo in any way I would be so thankful to leave a reference to my GitHub profile, thanks!


<!--TODO give somewhere link to docker hub project-->
<!--TODO write somewhere that the website for the project may not work at the moment because I shut down the entire infrastructure when I do not enhance the project in order to not spend money when I don't have to ;). But every relevant website's appearance should be available to see in this README.md-->
<!--TODO do all TODOs from each file on repo-->





