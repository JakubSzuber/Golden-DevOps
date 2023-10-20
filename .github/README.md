<div align="center" class="no-border">
  <img src="https://cdn-icons-png.flaticon.com/512/5266/5266248.png" alt="Golden-DevOps Logo">
  <br>
  <h3>Golden-DevOps is a fully open-source project that uses all core DevOps tools and best practices</h3>

  [![release](https://img.shields.io/github/v/release/JakubSzuber/Golden-DevOps)](https://github.com/JakubSzuber/Golden-DevOps/releases)
  [![Continuous Integration](https://github.com/JakubSzuber/Golden-DevOps/workflows/CI/badge.svg)](https://github.com/JakubSzuber/Golden-DevOps/actions/workflows/integration.yml)
  [![Continuous Delivery](https://github.com/JakubSzuber/Golden-DevOps/workflows/CD/badge.svg)](https://github.com/JakubSzuber/Golden-DevOps/actions/workflows/delivery.yml)
  [![Terraform Continuous Integration](https://github.com/JakubSzuber/Golden-DevOps/workflows/Terraform%20CI/badge.svg)](https://github.com/JakubSzuber/Golden-DevOps/actions/workflows/terraform-ci.yml)
  [![Terraform Continuous Delivery](https://github.com/JakubSzuber/Golden-DevOps/workflows/Terraform%20CD/badge.svg)](https://github.com/JakubSzuber/Golden-DevOps/actions/workflows/terraform-cd.yml)
  [![Helm CI/CD](https://github.com/JakubSzuber/Golden-DevOps/workflows/Helm%20Chart/badge.svg)](https://github.com/JakubSzuber/Golden-DevOps/actions/workflows/helm-test.yml)
</div>

Golden-DevOps is a fully open-source project that uses all core DevOps tools and practices. It is a complete example of the repository with the implementation of automation, scalability, containerization, availability, and DevOps/GitOps philosophy. From the perspective of the application logic, it's the simplest React-Nginx app with one static page. Using code from this repo and with help of instructions and tips in this README you can very easily deploy this app in AWS EKS through Terraform.

The purpose of this repo is to showcase how to set up an app and everything related to it in the most modern way with usage of DevOps/GitOps tools and best practises, so at the end you will have working 3 separete and practically identical environment (Development, Staging/QA, Production) and each o them will have two domains, one with TLS secured React page and the second one for TLS secured ArgoCD Dashboard.

After the right setup (mostly changing the values for your particular case - more [here](https://github.com/JakubSzuber/Golden-DevOps#required-modifications)) it's only a matter of a single click to set up absolutely everything (above described infrastructure with 3 environments and a bunch of repository, development stuff that got a lot of automation in it) and also single click to clear the entire infrastructure (except few very simple stuff that was created manually like e.g. Route 53 record).

> **Note**
> Currently, [I](https://github.com/JakubSzuber) am the only one creator and maintainer of the code and ideas for this repo, and i would be so thanksful for any feedback and GitHub stars, regards!

### Characteristics of an app that would use this repo:

- <b>Full scability</b> - This project has implemented the Horizontal Pod Autoscaler (HPA) that ensures the right amount of pod based on the current traffic load. Furthermore, there is Karpeneter that in case of an overwhelm on the EC2 instances can spin up the new ones in the right size depending on the needs. This project is fully scalable but of course, you are able to control the minimum and maximum number of EC2 instances that you want or are able to run. In [eks/main.tf](https://github.com/JakubSzuber/Golden-DevOps/blob/main/terraform-infrastructure/eks/main.tf) file you can set the "min_size", "max_size", "desired_size" and other configuration of your EC2 instances (EKS managed nodes).
- <b>High availability</b> - This project places EC2 instances across different VPC Subnets which ensures that in case of a failure of the Availability Zone our app will be still running. Furthermore, full scalability also ensures that our app has no downtime because of the traffic overload.
- <b>Automated updates with zero downtime</b> - This project is created along with DevOps practices. In a nutshell application lifecycle ([more here](https://github.com/JakubSzuber/Golden-DevOps/tree/main#source-code-pipeline)) looks like that: developer merge a PR with changes and the [workflow](https://github.com/JakubSzuber/Golden-DevOps/blob/main/.github/workflows/delivery.yml) responsible for CD builds a new container with the newest applied changes and push it to DockerHub Registry, and after that changes the used tag in K8s deployments for each environment so in their configuration is used the newest container's tag with applied changes. Then Argo CD running within each cluster automatical notices that change and deploy the new container gradually - in each pod but not on all of them at the same time, so there is practically no downtime because the traffic is
continually routed to either the pod with changes or old pod that waits for its turn. This gives us extremely easy and potentially very frequent updates for our app (for both the Development and Operations teams) whenever we want.
- <b>Ease of replication and short Mean Time to Recovery (MTTR)</b> - This project has defined the entire infrastructure in Terraform files that don't replicate themselves (to manage multiple env Terraform Workspaces is used). This gives us the ability to very easily and rapidly deploy some new environment or spin up the environment that was already created but for some reason failed. We don't have to create anything manually in some cloud provider's console and we don't have to make any new files/directories to spin up a new environment from scratch.
- <b>Great development experience</b> - This project has a load of features that significantly help the development team. First of all, when a developer wants to start the work with that project it's only a matter of cloning a repo and executing a single command (docker compose up) to spin up everything required to run a development environment to work properly. Guide about development [here](https://github.com/JakubSzuber/Golden-DevOps/tree/main#development-setup). Furthermore, there is a [.vscode](https://github.com/JakubSzuber/Golden-DevOps/tree/main/.vscode) directory that configures settings, debugging, and recommended useful extensions if you use VCS. After you make the setup you can modify the source code in [src](https://github.com/JakubSzuber/Golden-DevOps/tree/main/src) or [public](https://github.com/JakubSzuber/Golden-DevOps/tree/main/public) and changes will be automatically applied without need to restart, rebuild the container or anything like that. After you decide that you want to apply the changes to the remote repo then create a PR. Everything related to CI will be automatically by GitHub Actions workflow made so any o both developer and operations teams don't have to worry about manually ensuring that the quality of the changes is acceptable. After your PR is reviewed and merged the GitHub Actions workflow will automatically do everything related to CD (and the only manual thing will be the review before deploying to production). Furthermore, a lot of other tasks are completely automated to reduce the work of the developers. See below point.
- <b>Other automations</b> - This project uses a lot of GHA workflow to automate numerous tasks. Examples of automated tasks are - publishing new releases, marking/deleting old PR and Issues, version updates of GHA workflows' actions, Terraform modules and providers, dependencies in package.json and package-lock.json, and obviously lifecycles of source code, Terraform files, and Helm Chart. To insight more about what things are automated through GHA workflows see [.github/workflows](https://github.com/JakubSzuber/Golden-DevOps/tree/main/.github/workflows).
TODO OOOOOOOOOO typos unchecked below:
- <b>Easy rollbacks</b> - This project has implemented Argo CD and stores everything as a code within Git repo. This gives us very easy rollbacks because it's only a matter of undoing a particular commit by `git revert` or `git remove` and the previous state of everything will be restored, no matter if is it a thing related to Terraform file(s), source code or anything else. For example when you undo a commit that was doing a change in Terraform files then GHA workflows responsible for Terraform CI/CD will apply the changes. Another example is that you want to go back to the previous version of your main application (actually the previous container's tag), then you just have to undo a commit(s) that was pushed automatically by [delivery.yml](https://github.com/JakubSzuber/Golden-DevOps/tree/main/.github/workflows/delivery.yml) and Argo CD will automatically notice that tags of the main application container changed and apply the changes. So a real state of everything related to the application will reflect the exact state of current files stored within the repo.
- <b>Low latency</b> - This project uses static content served by Nginx which is later cached by AWS CDN - Amazon CloudFront, so the latency of the application should be minimal (also bacause the source code in this project is very simple, in order to only showcase how to create React app).
- <b>Security</b> - This project uses HTTPS for bot connection between clients and AWS ALB and between AWS ALB and containers. The certificates for the encryption between AWS ALB and the containers are automatically managed by K8s cert-manager. Furthermore every sensitive data is stored as GitHub Secret what enusre safesty for data like passwords and sensitive URLs. Moreover there are a lot of security-related automations within GHA workflows, like e.g. blocking teh PR if critical vulnerabilities are found, uploading a security results after each newly deployed change, etc.
- <b>Ease of extensibility</b> - This project showcase how to create and maintain modern application and everything around it, instead of createding complex and comprehensive application logic. The source code of the project itself is very simple, and everyyhing is pretty easy to modify and maintain because of parameterization in core elements.
- <b>Great resource utilization</b> - This project is fully scalable (in term of both the nodes and containers) to meet the exact needed depand. Moreover the desired, minimal, maximal number of nodes are based on the [calculator](https://learnk8s.io/kubernetes-instance-calculator) that shows most efficient configurations (you can also set the EC2 instance types that can be possibly used).
- <b>And a lot more...</b>

### Automation and development experience
XXXprzenies moze texkst z tych 2 punktow??


<details>
<summary><b>Click to see the project structure:</b></summary>

```$ tree Golden-DevOps
Golden-DevOps/
├── .git
│   └── ...
├── .github
│   ├── ISSUE_TEMPLATE
│   │   ├── bug_report.yml
│   │   ├── feature_request.yml
│   │   └── typo.yml
│   ├── linters
│   │   └── .hadolint.yaml
│   ├── workflows
│   │   ├── delivery.yml
│   │   ├── github-release.yml
│   │   ├── helm-test.yml
│   │   ├── infra-cleanup.yml
│   │   ├── integration.yml
│   │   ├── playground.yml
│   │   ├── reusable-change-tag.yml
│   │   ├── reusable-infra-cleanup.yml
│   │   ├── reusable-terraform.yml
│   │   ├── stale.yml
│   │   ├── terraform-cd.yml
│   │   └── terraform-ci.yml
│   ├── CHANGELOG.md
│   ├── CODEOWNERS
│   ├── CODE_OF_CONDUCT.md
│   ├── CONTRIBUTING.md
│   ├── FUNDING.yml
│   ├── PULL_REQUEST_TEMPLATE.md
│   ├── README.md
│   ├── SECURITY.md
│   └── dependabot.yml
├── .nginx
│   └── nginx.conf
├── .vscode
│   ├── extensions.json
│   ├── launch.json
│   └── settings.json
├── aws
│   ├── gh-action-role.json
│   └── gh-actions-inline-policy.json
├── healthchecks
│   └── postgres-healthcheck
├── helm-charts
│   └── main-chart
│       ├── templates
│       │   ├── tests
│       │   │   └── test-connection.yaml
│       │   ├── NOTES.txt
│       │   ├── apiservice.yaml
│       │   ├── clusterrole.yaml
│       │   ├── clusterrolebinding.yaml
│       │   ├── configmap.yaml
│       │   ├── deployment.yaml
│       │   ├── hpa.yaml
│       │   ├── metrics-server-deployment.yaml
│       │   ├── metrics-server-service.yaml
│       │   ├── namespace.yaml
│       │   ├── rolebinding.yaml
│       │   ├── secret.yaml
│       │   ├── service.yaml
│       │   └── serviceaccount.yaml
│       ├── .helmignore
│       ├── Chart.yaml
│       ├── values-dev.yaml
│       ├── values-prod.yaml
│       ├── values-staging.yaml
│       └── values.yaml
├── images
│   ├── compose.png
│   └── output.png
├── public
│   ├── favicon.ico
│   ├── index.html
│   ├── logo192.png
│   ├── logo512.png
│   ├── manifest.json
│   └── robots.txt
├── src
│   ├── App.css
│   ├── App.js
│   ├── App.test.js
│   ├── index.css
│   ├── index.js
│   ├── logo.svg
│   ├── reportWebVitals.js
│   └── setupTests.js
├── terraform-infrastructure
│   ├── argocd
│   │   ├── manifests
│   │   │   ├── app-repos.yaml
│   │   │   ├── app-set.tpl
│   │   │   ├── ingress.tpl
│   │   │   ├── install.yaml
│   │   │   ├── namespace.yaml
│   │   │   └── service-grpc.yaml
│   │   ├── .terraform.lock.hcl
│   │   ├── backend.tf
│   │   ├── data.tf
│   │   ├── kubectl-provider.tf
│   │   ├── main.tf
│   │   ├── providers.tf
│   │   ├── terraform-dev.tfvars
│   │   ├── terraform-prod.tfvars
│   │   ├── terraform-staging.tfvars
│   │   ├── variables.tf
│   │   └── versions.tf
│   ├── eks
│   │   ├── .terraform.lock.hcl
│   │   ├── backend.tf
│   │   ├── data.tf
│   │   ├── karpenter-controller.txt
│   │   ├── lb-controller.tf
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── providers.tf
│   │   ├── terraform-dev.tfvars
│   │   ├── terraform-prod.tfvars
│   │   ├── terraform-staging.tfvars
│   │   ├── variables.tf
│   │   └── versions.tf
│   └── vpc
│       ├── .terraform.lock.hcl
│       ├── backend.tf
│       ├── main.tf
│       ├── outputs.tf
│       ├── providers.tf
│       ├── terraform-dev.tfvars
│       ├── terraform-prod.tfvars
│       ├── terraform-staging.tfvars
│       ├── variables.tf
│       └── versions.tf
├── .dockerignore
├── .gitattributes
├── .gitignore
├── Dockerfile
├── LICENSE
├── docker-compose.dev.yml
├── docker-compose.test.yml
├── package-lock.json
└── package.json
```
</details>

# Stack

<div align="center">
<h1 style="margin:-10px;margin-bottom:0">Infrastructure:</h1>
<img width="55" src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/amazonwebservices/amazonwebservices-plain-wordmark.svg" alt="AWS"/>&nbsp;&nbsp;<img width="55" src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/terraform/terraform-original.svg" alt="terraform"/>&nbsp;<img width="55" src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/linux/linux-original.svg" alt="linux"/>

<br>
<h1 style="margin:-10px;margin-bottom:0">Deployment:</h1>
<img width="55" src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/docker/docker-original.svg" alt="docker"/>&nbsp;&nbsp;<img width="55" src="https://github.com/JakubSzuber/Golden-DevOps/blob/main/images/compose.png" alt="docker compose"/>&nbsp;&nbsp;<img width="55" src="https://helm.sh/img/helm.svg" alt="Helm Charts"/>&nbsp;&nbsp;&nbsp;<img width="55" src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/kubernetes/kubernetes-plain.svg" alt="kubernetes"/>
<img width="55" src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/argocd/argocd-original.svg" alt="Argo CD"/>&nbsp;
<img width="55" src="https://avatars.githubusercontent.com/u/54465427?v=4" alt="github actions"/>

<br>
<h1 style="margin:-10px;margin-bottom:0">Application Logic:</h1>
<img width="55" src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/nginx/nginx-original.svg" alt="Nginx"/>&nbsp;&nbsp;&nbsp;<img width="55" src="https://upload.wikimedia.org/wikipedia/commons/thumb/a/a7/React-icon.svg/2300px-React-icon.svg.png" alt="React"/>

<br>
<h1 style="margin:-10px;margin-bottom:0">Configuration Management:</h1>
<img width="55" src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/ansible/ansible-original.svg" alt="ansible"/>

<br>
<h1 style="margin:-10px;margin-bottom:0">Monitoring:</h1>
<img width="55" src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/prometheus/prometheus-original.svg" alt="prometheus"/>&nbsp;&nbsp;<img width="55" src="https://github.com/devicons/devicon/blob/master/icons/grafana/grafana-original.svg" alt="grafana"/>
</div>

# How to use the repo
> **Note**
> Example note...If you encounter any problems using this repo to create your own infrastructure, try deleting everything and starting over. When creating several complex infrastructures sometimes there may be a temporary problem that may be at fault with AWS. However, if that doesn't help feel free to use the [issue](https://github.com/JakubSzuber/Golden-DevOps/issues/new/choose) or [discussions](https://github.com/JakubSzuber/Golden-DevOps/discussions) section.

If you don't have any internet domain then register one manually e.g. in the AWS console from Route 53 interface and create a hosted zone for in Route 53 (if you register a domain through Route 53 then the hosted zone is automatically created for that domain)
Create an ACM cert issued for domains yourdomain.com, *.yourdomain.com, and *.argo.yourdomain.com (you can do this e.g. in the AWS console from ACM 53 interface). After that create CNAME record for each domain (in the AWS console from ACM 53 interface there is a button "Create records in Route 53") in order to allow AWS to validate your domains.
Create an S3 Bucket for a Terraform remote state. It should have enabled versioning, default encryption, and object lock setting (under "Advanced settings").
Create a DynamoDB table with a partition key "LockID" type string.
XXSetup Terrafom infra
XXXAdd 6 A type aliases records with the right Ingress Load Balancer URL (each pair of aliases for the specific environment should have the right specific Load Balancer URL assigned). AWS LoadBalancer Controller dynamically deploy a new LB or add new ingress into the same LB based on the setup.https://fewmorewords.com/eks-with-argocd-using-terraform#heading-5-post-deployment-stuff
XXXThen make sure you have right configured ~/.aws/credentials file on XXX so you have configured a default IAM user and IAM user that is used to access Argo CD (in this repo jakubszuber-admin). Both can be the same IAM user with the same AWS Access Key. MAYBE JUST OPENID SO THE BELOW LINE WON'T BE NEEDED.
Then Add your IAM user (eksadmin in my case) to the AWS configuration. Then update the kubeconfig to get access to your brand new EKS cluster and grab the ArgoCD default password from the argocd-initial-admin-secret.https://fewmorewords.com/eks-with-argocd-using-terraform#heading-5-post-deployment-stuff
export AWS_DEFAULT_PROFILE=jakubszuber-admin ALBO set AWS_DEFAULT_PROFILE=jakubszuber-admin
aws sts get-caller-identity
aws eks update-kubeconfig --name \<name of one of the clusters> --region us-east-1 --profile jakubszuber-admin
kubectl get secrets -n argocd
kubectl get secret argocd-initial-admin-secret -n argocd --template={{.data.password}} | base64 -d
Now you can log in as "admin" to argo.yourdomain.com or \<name of the environment>.argo.yourdomain.com


generate your own "cert.pem" and "key.pem" by command `openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 750 -nodes`. Then you can print them by `cat cert.pem | base64 -w 0` and `cat key.pem | base64 -w 0` so you are able to copy them from the terminal and insert as values to secret.yaml file that is in Helm chart. **Currently this method of using self-signed certificates is temporary and it would be better to use some other TLS certificate approach but if you are ok with then remember to not expose the values of "cert.pem" and "key.pem" in GitHub repo (this repo is showcase example and self-signed certificates will be removed in progress for this repo). Making the better and more secure approach is in progress for that repo!**
XXXSet up the following GitHub secrets (the same for both Actions and Dependabot): DOCKERHUB_TOKEN, DOCKERHUB_USERNAME, SNYK_TOKEN, SLACK_WEBHOOK_URL, SLACK_WEBHOOK_URL2
Do https://github.com/marketplace/actions/slack-send#technique-3-slack-incoming-webhook
Change all occurrences of "jakubszuber/react-nginx-image" and "react-nginx-image" to your image
Setup OpenID Connect between GitHub and AWS
Configure Snyk account with repo
Create "Staging" and "Production" GitHub environments and then add a protection role for "Production" so this environment will require reviewers (add some reviews that will be able to allow for changes deployment)
Create the Identity provider in AWS IAM with Provider type "OpenID Connect", Provider URL "https://token.action.githubcontent.com", Audience "sts.amazonaws.com". Then create an IAM Role with a Trusted entity type "Custom trust policy" and content similar to [this](https://github.com/JakubSzuber/Golden-DevOps/blob/main/aws/gh-action-role.json) (remember to change the IAM user number and name of the GitHub user and repo), then add an IAM Policy with a content similar to [this](create an IAM Role with a Trusted entity type "Custom trust policy" and content similar to [this](https://github.com/JakubSzuber/Golden-DevOps/blob/main/aws/gh-action-role.json).

> **Note**
> By the way, if you use VSC then you probably want to have features (highlighting, recommendations, etc) for .tpl files the same as you probably already have for your YAML files. To do so in VSC open e.g. ingress.tpl and in the bottom-right corner click on "plain-text", then scroll down and click on "YAML" so from now you will have .tpl files associated with the YAML files (treated the same as YAML files), what can be very helpful!

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

# Required modifications

XXYou have to modify following things, specific for your case environment variables, secrets, dockerhub repository, domain name, s3 bucket's name, dynamodb tables's name, etc
Lorem ipsum dolor sit amet consectetur adipisicing elit. Maxime mollitia,
molestiae quas vel sint commodi repudiandae consequuntur voluptatum laborum.

# Development setup

To dev work after cloning the repo use `docker compose -f docker-compose.dev.yml up -d --build` for the initial setup and fixing temporary errors, after executing this
command you can just start coding (the changes will be applied after each save) and you will see the website on [localhost:80](http://localhost:80) or [localhost:3000](http://localhost:3000).
In order to debug code in VSC make sure that you have [.vscode/launch.json](https://github.com/JakubSzuber/test-project/blob/main/.vscode/launch.json) from that project.
Note that the initial start, compiling and automatic reload of the website's content can take a little more time than usual. If you encounter any problems with dev
work try to restart the container, your whole Docker and eventually WSL2.

To shut down Docker Compose use `docker compose -f docker-compose.dev.yml -v down`.

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
XXXUse the destroy workflow...and then manually destroy A records (CNAME also if you want to delete the TLS certificate) of your hosted zone, DynamoDB table, S3 Bucket for the Terraform Remote State, and then you can delete the TLS certificate, xxx

XXXWhile deleting the Terraform-managed infrastructure it's good to watch the workflow's logs so in case of a long deletion process of some resource (especially VPC that can take a dozen of minutes although deletion timeout of VPC resource is only 5 minutes) go to the AWS Console and manually delete this resource. This will speed up the deletion process and prevent the workflow's errors caused by deletion timeout errors of the Terraform Resources.
XXXIn case of a timeout failure of workflow responsible for cleaning up the entire Terraform-managed infrastructure (infra-cleanup.yml) you have to comment out the right environment in infra-cleanup.yml and/or comment out the particular lines responsible for planning and destroying specific module(s) in reusable-infra-cleanup.yml.

XXXFor example in case of a timeout error because deletion of production VPC took too long, first go to infra-cleanup.yml and comment out the json values responsible for dev and staging environments, then go to reusable-infra-cleanup.yml and in "Terraform Plan" step delete lines (in this case first 6 lines) are temporarily useless because argocd and eks modules were already deleted and attempt to do a "terraform plan" or "terraform destroy" on those modules will fail among others because the EKS Cluster endpoint is already deleted. Remember to change "cd ../vpc" to "cd vpc"). Then delete the steps responsible for deleting the argocd and eks modules. Now you can finally execute the workflow infra-cleanup.yml once again and then undo the changes that you temporarily made to infra-cleanup.yml and reusable-infra-cleanup.yml.

## Contributing

Want to contribute to this project? Check out the
[contributing documentation](https://github.com/JakubSzuber/Golden-DevOps/blob/main/.github/CONTRIBUTING.md). Feel free to write on [Discussions](https://github.com/JakubSzuber/Golden-DevOps/discussions). You can also contact me on my Gmail [jszuber06@gmail.com](https://jszuber06@gmail.com).

If you find an issue, please report it on the
[issue tracker](https://github.com/JakubSzuber/Golden-DevOps/issues/new/choose).

## License and Authorship

This project uses [MIT License](https://github.com/JakubSzuber/Golden-DevOps/blob/main/LICENSE) and was entirely created by myself. If you want to publically use this repo in any way I would be so thankful to leave a reference to my GitHub profile, thanks!


<!--TODO give somewhere link to docker hub project-->
<!--TODO write somewhere that the website for the project may not work at the moment because I shut down the entire infrastructure when I do not enhance the project in order to not spend money when I don't have to ;). But every relevant website's appearance should be available to see in this README.md-->
<!--TODO write somewhere about the costs of the entire infrastructure, and what can cause price fluctuations (will EC2 instances will be placed on public or private subnets, what will be the size, number, and work hours of those instances, do you already have a purchased domain, etc.)-->
<!--TODO Write somewhere that: Implementation of another service like for instance new Postgres container is very facilitated. To do so uncomment and possibly modify the following files depending on your needs: [docker-compose.dev.yml](https://github.com/JakubSzuber/Golden-DevOps/blob/main/docker-compose.dev.yml), [docker-compose.test.yml](https://github.com/JakubSzuber/Golden-DevOps/blob/main/docker-compose.test.yml), [integration.yml](https://github.com/JakubSzuber/Golden-DevOps/blob/main/.github/workflows/integration.yml)-->
<!--TODO write what contains each terraform module (remember that "eks" module contains eks itself as well as the eks addons)-->
<!--TODO write something about which and how Gitops deployment models ware implemented (push-base and pull-based)-->
<!--TODO write something about which git branching strategy is used in this repo (probably feature branches and/or forking reporitory....)-->
<!--TODO create github kanban "Project" and write about it on readme-->
<!--TODO Do all of TODO from every workflow and from my notes-->
<!--TODO Fix the typos-->
