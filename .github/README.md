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

> **Important**
> Currently, [I](https://github.com/JakubSzuber) am the only one creator and maintainer of the code and ideas for this repo, and I would be so thanksful for any feedback and GitHub stars, regards!

### Characteristics of an app that would use this repo:

- <b>Full scability</b> - This project has implemented the Horizontal Pod Autoscaler (HPA) that ensures the right amount of pod based on the current traffic load. Furthermore, there is Karpeneter that in case of an overwhelm on the EC2 instances can spin up the new ones in the right size depending on the needs. This project is fully scalable but of course, you are able to control the minimum and maximum number of EC2 instances that you want or are able to run. In [eks/main.tf](https://github.com/JakubSzuber/Golden-DevOps/blob/main/terraform-infrastructure/eks/main.tf) file you can set the "min_size", "max_size", "desired_size" and other configuration of your EC2 instances (EKS managed nodes).
- <b>High availability</b> - This project places EC2 instances across different VPC Subnets which ensures that in case of a failure of the Availability Zone our app will be still running. Furthermore, full scalability also ensures that our app has no downtime because of the traffic overload.
- <b>Automated and rapid updates with zero downtime</b> - This project is created along with DevOps practices. In a nutshell application lifecycle ([more here](https://github.com/JakubSzuber/Golden-DevOps/tree/main#source-code-pipeline)) looks like that: developer merge a PR with changes and the [workflow](https://github.com/JakubSzuber/Golden-DevOps/blob/main/.github/workflows/delivery.yml) responsible for CD builds a new container with the newest applied changes and push it to DockerHub Registry, and after that changes the used tag in K8s deployments for each environment so in their configuration is used the newest container's tag with applied changes. Then Argo CD running within each cluster automatical notices that change and deploy the new container gradually - in each pod but not on all of them at the same time, so there is practically no downtime because the traffic is
continually routed to either the pod with changes or old pod that waits for its turn. This gives us extremely easy and potentially very frequent updates for our app (for both the Development and Operations teams) whenever we want.
- <b>Ease of replication and short Mean Time to Recovery (MTTR)</b> - This project has defined the entire infrastructure in Terraform files that don't replicate themselves (to manage multiple env Terraform Workspaces is used). This gives us the ability to very easily and rapidly deploy some new environment or spin up the environment that was already created but for some reason failed. We don't have to create anything manually in some cloud provider's console and we don't have to make any new files/directories to spin up a new environment from scratch.
- <b>Great development experience</b> - This project has a load of features that significantly help the development team by e.g. making the setup process very effortless and rapid, automating repetitive and complicated tasks, helping with configuring IDE. More about development experience ([here](https://github.com/JakubSzuber/Golden-DevOps/tree/main#source-code-pipeline)). Furthermore, a lot of other tasks are completely automated to reduce the work of the developers. See below point.
- <b>Other automations</b> - This project uses a lot of GHA workflow to automate numerous tasks. Examples of automated tasks are - publishing new releases, marking/deleting old PR and Issues, version updates of GHA workflows' actions, Terraform modules and providers, dependencies in package.json and package-lock.json, and obviously lifecycles of source code, Terraform files, and Helm Chart. To insight more about what things are automated through GHA workflows see [.github/workflows](https://github.com/JakubSzuber/Golden-DevOps/tree/main/.github/workflows).
- <b>Easy rollbacks</b> - This project has implemented Argo CD and stores everything as a code within Git repo. This gives us very easy rollbacks because it's only a matter of undoing a particular commit by `git revert` or `git remove` and the previous state of everything will be restored, no matter if is it a thing related to Terraform file(s), source code or anything else. For example when you undo a commit that was doing a change in Terraform files then GHA workflows responsible for Terraform CI/CD will apply the changes. Another example is that you want to go back to the previous version of your main application (actually the previous container's tag), then you just have to undo a commit(s) that was pushed automatically by [delivery.yml](https://github.com/JakubSzuber/Golden-DevOps/tree/main/.github/workflows/delivery.yml) and Argo CD will automatically notice that tags of the main application container changed and apply the changes. So a real state of everything related to the application will reflect the exact state of current files stored within the repo.
- <b>Low latency</b> - This project uses static content served by Nginx which is later cached by AWS CDN - Amazon CloudFront, so the latency of the application should be minimal (also because the source code in this project is very simple, in order to only showcase how to create React app).
- <b>Security</b> - This project uses HTTPS for bot connection between clients and AWS ALB and between AWS ALB and containers. The certificates for the encryption between AWS ALB and the containers are automatically managed by the K8s cert-manager. Furthermore, every sensitive data is stored as GitHub Secret which ensures safety for data like passwords and sensitive URLs. Moreover, there is a lot of security-related automation within GHA workflows, like e.g. blocking the PR if critical vulnerabilities are found, uploading security results after each newly deployed change, etc.
- <b>Ease of extensibility</b> - This project showcases how to create and maintain modern application and everything around it, instead of creating complex and comprehensive application logic. The source code of the project itself is very simple, and everything is pretty easy to modify and maintain because of parameterization in core elements.
- <b>Great resource utilization</b> - This project is fully scalable (in terms of both the nodes and containers) to meet the exact needed demand. Moreover, the desired, minimal, maximal number of nodes is based on the [calculator](https://learnk8s.io/kubernetes-instance-calculator) that shows the most efficient configurations (you can also set the EC2 instance types that can be possibly used).
- <b>And a lot more...</b>

### Development experience

This project has a load of features that significantly help the development team. First of all, when a developer wants to start the work with that project it's only a matter of cloning a repo and executing a single command (docker compose up) to spin up everything required to run a development environment to work properly. Guide about development [here](https://github.com/JakubSzuber/Golden-DevOps/tree/main#development-setup).

Furthermore, there is a [.vscode](https://github.com/JakubSzuber/Golden-DevOps/tree/main/.vscode) directory that configures settings, debugging, and recommended useful extensions if you use VCS. After you make the setup you can modify the source code in [src](https://github.com/JakubSzuber/Golden-DevOps/tree/main/src) or [public](https://github.com/JakubSzuber/Golden-DevOps/tree/main/public) and changes will be automatically applied without need to restart, rebuild the container or anything like that.

After you decide that you want to apply the changes to the remote repo then create a PR. Everything related to CI will be automatically by GitHub Actions workflow made so any o both developer and operations teams don't have to worry about manually ensuring that the quality of the changes is acceptable. After your PR is reviewed and merged the GitHub Actions workflow will automatically do everything related to CD (and the only manual thing will be the review before deploying to production).

Moreover, a lot of other tasks are completely automated to reduce the work of the developers. Examples of automated tasks are - publishing new releases, marking/deleting old PR and Issues, version updates of GHA workflows' actions, Terraform modules and providers, dependencies in package.json and package-lock.json, and obviously lifecycles of source code, Terraform files, and Helm Chart.

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
│   └── local-preview.png
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


# Requirements

You don't need to have everything from described below "Full usage" point to use the repo for some of the basic purposes like e.g. having automated pipeline(s) or having a development environment for React-Nginx app. Below there is described what is required for which kind of usage of this repo:

### Full usage:

(Be able to use every functionality from this project)

- Git, Node.js, Docker and Docker Compose (highly recommended to have Docker Desktop) installed on the local computer.
- GitHub Account, AWS Account, DockerHub Account, Snyk Account (with your integrated repo), Slack Account and Slack App with at least 2 Webhook URLs to channels (guide on how to use Slack GHA step [here](https://github.com/marketplace/actions/slack-send#technique-3-slack-incoming-webhook)).
- Right configured AWS directory (~/.aws) on your local computer. You can use `aws configure` command to set the default AWS profile's Access Key ID and Access Key Name (data will be saved in file ~/.aws/credentials), and default AWS region (use the same as you use in other files) and format of the output (data will be saved in file ~/.aws/config). Then open ~/.aws/credentials file and create a new AWS profile, that will be used for accesing the EKS cluster from your local computer (in this repo this AWS profile is called "jakubszuber-admin"). This new AWS profile could have the same Access Key's ID and Name as your default profile but don't have to.

### Have automated pipelines:

(GHA that will automate lifecycle of the source code, Terraform files, Helm Chart, and other less important tasks)

- GitHub Account, AWS Account, DockerHub Account, Snyk Account (with your integrated repo), Slack Account and Slack App with at least 2 Webhook URLs to channels
(guide on how to use Slack GHA step [here](https://github.com/marketplace/actions/slack-send#technique-3-slack-incoming-webhook)).

### Spin up the infrastructure:

(Deploy 3 environments with main website and Argo CD Dashboard for each one)<br>(Second point if you want to have access to EKS cluster from your local computer)

- GitHub Account, AWS Account, DockerHub Account, Snyk Account (with your integrated repo), Slack Account and Slack App with at least 2 Webhook URLs to channels (guide on how to use Slack GHA step [here](https://github.com/marketplace/actions/slack-send#technique-3-slack-incoming-webhook).
- Right configured AWS directory (~/.aws) on your local computer. You can use `aws configure` command to set the default AWS profile's Access Key ID and Access Key Name (data will be saved in file ~/.aws/credentials), and default AWS region (use the same as you use in other files) and format of the output (data will be saved in file ~/.aws/config). Then open ~/.aws/credentials file and create a new AWS profile, that will be used for accesing the EKS cluster from your local computer (in this repo this AWS profile is called "jakubszuber-admin"). This new AWS profile could have the same Access Key's ID and Name as your default profile but don't have to.

### Have development environment for React-Nginx app

(Be able to use a single command to be able to develop React-Nginx app Docker container):

- Git, Node.js, Docker and Docker Compose (highly recommended to have Docker Desktop) installed on the local computer.

### Have GitHub file for the repo

(Have configured GitHub files that help to use repo):

- GitHub Account.
- Git installed on the local computer.


# Required modifications

If you want to use all of the repository functionalities then there are some of the variables that will be specific for your case. Files and directories that require the most changes are listed at the end of this section (those are not the only places where you have to change values).

This repo is a real-world working example so it contains values specific only to this repo, so for your usage, you have to change below values (or some of them if you don't use the entire repo):
- S3 bucket's name (in this repo "golden-devops-bucket")
- DynamoDB table's name (in this repo "golden-devops-dynamodb")
- Domain name (in this repo "goldendevops.com")
- AWS Region (in this repo "us-east-1")
- AWS Profile used to access the EKS cluster from your local computer (in this repo "jakubszuber-admin")
- Whole IAM Role (in this repo [gh-action-role.json](https://github.com/JakubSzuber/Golden-DevOps/blob/main/aws/gh-action-role.json))
- Whole IAM Policy (in this repo [gh-actions-inline-policy.json](https://github.com/JakubSzuber/Golden-DevOps/blob/main/aws/gh-actions-inline-policy.json))
- Whole Helm values.yaml file (in this repo [values.yaml](https://github.com/JakubSzuber/Golden-DevOps/blob/main/helm-charts/main-chart/values.yaml))
- Whole argocd/manifests directory (in this repo [argocd/manifests](https://github.com/JakubSzuber/Golden-DevOps/tree/main/terraform-infrastructure/argocd/manifests))
- Minimal, maximal, and desired number of nodes specified in eks/main.tf (in this repo [eks/main.tf](https://github.com/JakubSzuber/Golden-DevOps/blob/main/terraform-infrastructure/eks/main.tf))
- Privacy of the VPC Subnets specified in vpc/main.tf (in this repo [vpc/main.tf](https://github.com/JakubSzuber/Golden-DevOps/blob/main/terraform-infrastructure/vpc/main.tf))
- Name of Helm Chart specified in Chart.yaml (in this repo "golden-devops-chart")
- Docker container name and its tag (in this repo "jakubszuber/react-nginx-image" and "stable-DATE-SHORT-SHA")
- All of the links for the GitHub repo (in this repo "https://github.com/JakubSzuber/Golden-DevOp")
- GitHub user used within files of [.github dir](https://github.com/JakubSzuber/Golden-DevOps/blob/main/.github) (in this repo "JakubSzuber")
- GitHub secrets (the same, duplicated for both Actions and Dependabot secrets). Names of the secrets should be the same as: DOCKERHUB_TOKEN, DOCKERHUB_USERNAME, SLACK_WEBHOOK_URL, SLACK_WEBHOOK_URL2, SNYK_TOKEN
- And obviosly this whole README.md is unique for this repository.

The files/dirs that contain a lot of those "your-specific" values are:
- All of terraform-infrastructure/\<MODULE>/main.tf files
- All of terraform-infrastructure/\<MODULE>/data.tf files
- Chart.yaml and all of 4 Helm values files within [helm-charts/main-chart](https://github.com/JakubSzuber/Golden-DevOps/blob/main/helm-charts/main-chart) directory
- Entire [argocd/manifests](https://github.com/JakubSzuber/Golden-DevOps/tree/main/terraform-infrastructure/argocd/manifests) directory
- Entire [aws](https://github.com/JakubSzuber/Golden-DevOps/blob/main/aws) directory
- Entire [.github](https://github.com/JakubSzuber/Golden-DevOps/blob/main/.github) directory directory


# How to use the repo (spin up everything)
> **Note**
> If you encounter any problems using this repo to create your own infrastructure, try deleting everything and starting over. When creating several complex infrastructures sometimes there may be a temporary problem that may be caused by e.g. AWS. However, if that doesn't help feel free to use the [issue](https://github.com/JakubSzuber/Golden-DevOps/issues/new/choose) or [discussions](https://github.com/JakubSzuber/Golden-DevOps/discussions) section.

### A few initial manual steps

First of all you need a internet domain. If you don't have one then register one manually e.g. in the AWS console from Route 53 interface and create a hosted zone for in Route 53 (if you register a domain through Route 53 then the hosted zone is automatically created for that domain).

Then create an TLS cert issued for domains yourdomain.com, *.yourdomain.com, and *.argo.yourdomain.com (you can do this e.g. in the AWS console from ACM 53 interface). After that create CNAME record for each domain (in the AWS console from ACM 53 interface there is a button "Create records in Route 53") in order to allow AWS to validate your domains.

Next step is creation of an S3 Bucket for the Remote State. It should have enabled versioning, default encryption, and object lock setting (under "Advanced settings"). Then create a DynamoDB table with a partition key "LockID" type string.

Another step is the creation of "Development", "Staging" and "Production" GitHub environments and then adding a protection role for "Production" so this environment will require reviewers (add some reviews that will be able to allow for deployments for the production environment).

One of the last steps is creation of AWS IAM Identity provider that will allow us to use OpenID Connect between GitHub Actions and AWS. To setup it go to Amazon IAM interface and create IAM Identity provider with Provider type "OpenID Connect", Provider URL "https://token.action.githubcontent.com", Audience "sts.amazonaws.com".

Then create an IAM Role with a Trusted entity type "Custom trust policy" and content similar to [this](https://github.com/JakubSzuber/Golden-DevOps/blob/main/aws/gh-action-role.json) (remember to change the IAM user number and name of the GitHub user and repo), then (for that IAM Role) create IAM Policy with Trusted entity type "Custom trust policy" with content similar to [this](https://github.com/JakubSzuber/Golden-DevOps/blob/main/aws/gh-action-role.json) (limit the actions and resources to the minimal scope possible for your case).

<!-- TODO Delete after implementing K8s cert-manager:-->
Generate your own "cert.pem" and "key.pem" by command `openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 750 -nodes`.
<br>Then you can print them by `cat cert.pem | base64 -w 0` and `cat key.pem | base64 -w 0` so you are able to copy them from the terminal and insert as values to secret.yaml file that is in Helm chart.
<br>**Currently this method of using self-signed certificates is temporary and it would be better to use some other TLS certificate approach but if you are ok with then remember to not expose the values of "cert.pem" and "key.pem" in GitHub repo (this repo is showcase example and self-signed certificates will be removed in progress for this repo). Making the better and more secure approach with using K8s cert-manager is in progress for that repo!**

### Spinning up the infrastructure (3 environments)

To initialize the whole infrastructure (3 environments) you just have to go to Actions section in your repo, find on the left bar the workflow called "Terraform CD", click on it and click "Run worfklow" button in order to manually execute this workflow. First will be deployed development environment, then staging, then production (you have to manually approve the deployment to production in interface of this wokrflow run). Deployment proccess for each environment should take 15 minutes on average.

After successfull run of the worklfow you have to create A type aliases records for the right domains and AWS ALB. If you use Amazon Route 53 go to its interface and add 6 A type alias records with the right Ingress Load Balancer URL (each pair of aliases for the specific environment should have the right specific Load Balancer URL assigned).

For example there is one of 3 pairs: "dev.yourdomain.com" and traffic routed to AWS ALB "dualstack.k8s-alb-111-222.us-east-1.elb.amazonaws.com." and "dev.argo.yourdomain.com" and traffic routed to the same AWS ALB. Do similar thing for staging and production (production will have pair of domains without env-specific subdomain - "yourdomain.com" and "argo.yourdomain.com").

> **Note**
> To find the right AWS ALB for the right pair of domains you can either enter the EC2->Load balancers or VPC interface to insight the infomation about in which VPC the specific AWS ALB is placed (name of the VPC will tell you which environment is that).

<!-- TODO add here screenshot of the finished Route 53 setup -->
<img width="100%" src="https://img.freepik.com/free-photo/grunge-black-concrete-textured-background_53876-124541.jpg" alt="A type aliases records"/>

<br>

Now you should be able to enter the main websites and Argo CD Dashboards (login page) for each environment. It doesn't matter if you use http:// or https:// because you will still be redirected to https. If you the error then probably you have to wait for the new domain's records to propagate. If you have a VPN then turning it on, especially on USA, can significantly reduce waiting time ([I](https://github.com/JakubSzuber) personally use and recommend Chrome extension [Urban VPN](https://chrome.google.com/webstore/detail/urban-vpn-proxy/eppiocemhmnlbhjplcgkofciiegomcon?utm_source=ext_sidebar&hl=en-US)).

Websites should be similar to below (but with different domain).

<!-- TODO add here screenshot of the webiste from the internet (link of main website) -->
<img width="100%" src="https://img.freepik.com/free-photo/grunge-black-concrete-textured-background_53876-124541.jpg" alt="Main website preview"/>
<br>
<!-- TODO add here screenshot of the webiste from the internet (link of argo cd website) -->
<img width="100%" src="https://img.freepik.com/free-photo/grunge-black-concrete-textured-background_53876-124541.jpg" alt="A type aliases records" alt="Argo CD Dashboard preview"/>

<br>Now you can connect to every EKS cluster from your local computer (below example process for connection to one of the clusters - to connect to another cluster start the process from the 4th step).

1. First of all make sure you have the right configured ~/.aws directory on your local computer so you have configured the AWS profile that is used to access Argo CD (in this repo "jakubszuber-admin").

2. Then create environment variable with AWS profile's name.

Windows:
```cmd
set AWS_DEFAULT_PROFILE=jakubszuber-admin
```

Linux/macOS:
```bash
export AWS_DEFAULT_PROFILE=jakubszuber-admin
```

3. Make sure that the right AWS profile is set:

```bash
aws sts get-caller-identity
```

4. Update the kubeconfig to get access to your newly created EKS cluster.
```bash
aws eks update-kubeconfig --name <name of one of the clusters> --region <used aws region> --profile jakubszuber-admin
```

5. Display and copy the Argo CD default password from the argocd-initial-admin-secret:

```bash
kubectl get secrets -n argocd
kubectl get secret argocd-initial-admin-secret -n argocd --template={{.data.password}} | base64 -d
```

Now you can log in as "admin" to <b>https://<disable link>argo.\<yourdomain>.com</b> or <b>https://\<environment>.argo.\<yourdomain>.com</b> depends on the cluster and see similar Argo CD Dashboard:

<img width="100%" src="https://github.com/JakubSzuber/Golden-DevOps/blob/main/images/argocd-dashboard.jpg?raw=true" alt="A type aliases records" alt="Argo CD Dashboard preview"/>


# Development setup

To dev work after cloning the repo use `docker compose -f docker-compose.dev.yml up -d --build` for the initial setup and fixing temporary errors, after executing this
command you can just start coding (the changes will be applied after each save) and you will see the website on [localhost:80](http://localhost:80) or [localhost:3000](http://localhost:3000).
In order to debug code in VSC make sure that you have [.vscode/launch.json](https://github.com/JakubSzuber/test-project/blob/main/.vscode/launch.json) from that project.
Note that the initial start, compiling and automatic reload of the website's content can take a little more time than usual. If you encounter any problems with dev
work try to restart the container, your whole Docker and eventually WSL2.

<!-- TODO add here demo of the right project -->
<details>
<summary><b>Click to see the demo</b></summary>

https://user-images.githubusercontent.com/90647840/213922371-848ff6b3-60a8-4db2-94fb-7b11dbf41b42.mov
</details>

On the initial run you should see a similar website on either [localhost:80](http://localhost:80) or [localhost:3000](http://localhost:3000):

<img width="100%" src="https://github.com/JakubSzuber/Golden-DevOps/blob/main/images/local-preview.png?raw=true" alt="Local website preview"/>

To shut down Docker Compose use `docker compose -f docker-compose.dev.yml -v down`.

> **Note**
> By the way, if you use VSC then you probably want to have features (highlighting, recommendations, etc) for .tpl files the same as you probably already have for your YAML files. To do so in VSC open e.g. ingress.tpl and in the bottom-right corner click on "plain-text", then scroll down and click on "YAML" so from now you will have .tpl files associated with the YAML files (treated the same as YAML files), what can be very helpful!


# Source code pipeline

The CI/CD pipeline of the source code is handled by 2 GHA workflows [integration.yml](https://github.com/JakubSzuber/Golden-DevOps/blob/main/.github/workflows/integration.yml) and [delivery.yml](https://github.com/JakubSzuber/Golden-DevOps/blob/main/.github/workflows/delivery.yml) that contains steps appropriate for particular role of each workflow,and obviosly both workflows are executed by different trigger events.

## CI stage

<img width="100%" src="https://github.com/JakubSzuber/Golden-DevOps/blob/main/images/CI-preview.jpg?raw=true" alt="Local website preview"/>

First workflow ([integration.yml](https://github.com/JakubSzuber/Golden-DevOps/blob/main/.github/workflows/integration.yml)) is triggered when a new PR is created of new commit for the PR was pushed (also it can be executed manually) for the main branch. Moreover at least one of the commits has to contain the file that is related with the main React-Nginx container [Dockerfile](https://github.com/JakubSzuber/Golden-DevOps/blob/main/.github/workflows/Dockerfile), [package.json](https://github.com/JakubSzuber/Golden-DevOps/blob/main/.github/workflows/package.json), [package-lock.json](https://github.com/JakubSzuber/Golden-DevOps/blob/main/.github/workflows/package-lock.json), or some file within [src](https://github.com/JakubSzuber/Golden-DevOps/blob/main/src) or [public](https://github.com/JakubSzuber/Golden-DevOps/blob/main/.github/workflows/public) directory except README.md files).

First are executed 4 jobs in parallel:
- <b>Link Repo</b> - lint files that was changed. You can comment/uncomment right lines to turn on/off options for linting the entire repo instead of only changed files, linting only specific file(s), or excluding from linting specific file(s).
- <b>Scan Code With Snyk</b> - perform Static Application Security Testing (SAST) testing on the entire repo to print all levels of found vulnerabilities and fail the job if any critical level vulnerability was found.
- <b>Build Test Image (Candidate)</b> - build a Docker image with the last stage that includes only unprivileged Nginx image, and push it to the GitHub Registry (which is treated as the playground registry where are stored both testing and official images). This container is a potential "candidate" for the new container responsible for the main React-Nginx website. The "candidate" image contains minimal software required to serve static React website through Nginx which makes it lightweight and secure.
- <b>Build Unit Test Image</b> - build Docker image with the stage for unit tesing. This is the only purpose of this container as it contains more dependencies within it (compared to the container build with the last step) required only for performing unit testing.

If the "Build Test Image (Candidate)" job is successful then 3 jobs are executed in parallel:
- <b>Test Deployment In Kubernetes</b> - spin up the k3d cluster, launch the entire Helm Chart, and perform smoke tests on the deployment. k3d is a lightweight wrapper to run k3s (Rancher Lab's minimal Kubernetes distribution) which makes it a great choice for purposes like that.
- <b>Scan Image With Snyk</b> - perform vulnerability testing with the usage of Snyk for the "candidate" Docker container to display all levels of vulnerabilities and fail the job if any critical vulnerability was found.
- <b>Scan Image With Trivy</b> - perform vulnerability testing with the usage of Trivy for the "candidate" Docker container to display all levels of vulnerabilities and fail the job if any critical vulnerability was found.

If the "Build Unit Test Image" job is successful then 1 job is executed:
- <b>Unit Test in Docker</b> - perform unit tests on the Docker image that was built for that purpose.

When all of the jobs end their work then the last job is executed - <b>"Notify Slack (Final CI Result)"</b> that is responsible for sending the message to the Slack channel about the result of the entire workflow. If any of the jobs will fail, be skipped, or be canceled then the end result of the workflow is "Failure" and the message with appropriate content and color is sent.

If any of the jobs fail or are canceled then the end result of the workflow is "Failure" which will be shown in the interface of the PR for which the workflow was executed.


## CD stage

<img width="100%" src="https://github.com/JakubSzuber/Golden-DevOps/blob/main/images/CD-preview.jpg?raw=true" alt="Local website preview"/>

Second workflow ([delivery.yml](https://github.com/JakubSzuber/Golden-DevOps/blob/main/.github/workflows/delivery.yml)) is triggered when a PR is merged or there was a direct push (also it can be executed manually) for the main branch. Moreover at least one of the commits has to contain the file that is related with the main React-Nginx container [Dockerfile](https://github.com/JakubSzuber/Golden-DevOps/blob/main/.github/workflows/Dockerfile), [package.json](https://github.com/JakubSzuber/Golden-DevOps/blob/main/.github/workflows/package.json), [package-lock.json](https://github.com/JakubSzuber/Golden-DevOps/blob/main/.github/workflows/package-lock.json), or some file within [src](https://github.com/JakubSzuber/Golden-DevOps/blob/main/src) or [public](https://github.com/JakubSzuber/Golden-DevOps/blob/main/.github/workflows/public) directory except README.md files).

First are executed 2 jobs in parallel:
- <b>Build Final Image</b> - build a Docker image with the last stage that includes only unprivileged Nginx image, and push it to both GitHub Registry (the same as "candidate") and DockerHub (where are stored only official images). It is a new container responsible for the main React-Nginx website. The "candidate" image contains minimal software required to serve static React website through Nginx which makes it lightweight and secure.
- <b>Scan Code With Snyk And Upload Results</b> - perform vulnerability testing with the usage of Snyk for the new Docker container to display all levels of vulnerabilities and upload the test results to Snyk online app and GitHub Code Scanning.





<!-- TODO in proggress from below -->




If the "Build Final Image" job is successful then 4 jobs are executed in parallel:
- <b>Deploy To Development / deploy-to-env</b> - XXX
- <b>Generate SBOM (Software Bill of Materials) For The Final Image</b> - XXX
- <b>Scan Image With Snyk</b> - perform vulnerability testing with the usage of Snyk for the "candidate" Docker container to display all levels of vulnerabilities and fail the job if any critical vulnerability was found.
- <b>Scan Image With Trivy</b> - perform vulnerability testing with the usage of Trivy for the "candidate" Docker container to display all levels of vulnerabilities and fail the job if any critical vulnerability was found.

If the "Deploy To Development / deploy-to-env" job is successful then 2 jobs are executed in consecutive order - <b>Deploy To Staging</b> -> <b>Deploy To Production</b>. Both jobs are exacly the same except for a different environment (moreover Production environment required manual approve from reviewer(s) before execution).

When all of the jobs end their work then the last job is executed - <b>"Notify Slack (Final CI Result)"</b> that is responsible for sending the message to the Slack channel about the result of the entire workflow. If any of the jobs will fail, be skipped, or be canceled then the end result of the workflow is "Failure" and the message with appropriate content and color is sent.

If any of the jobs fail or are canceled then the end result of the workflow is "Failure" which will be shown in the interface of the PR for which the workflow was executed.


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

![](https://img.freepik.com/free-photo/grunge-black-concrete-textured-background_53876-124541.jpg)

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

> **Warning**
> TODO XXX

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
<!--TODO write what contains each terraform module (remember that "eks" module contains eks itself as well as the eks addons). Rememeber to write sth like "AWS LoadBalancer Controller dynamically deploy a new LB or add new ingress into the same LB based on the setup" https://fewmorewords.com/eks-with-argocd-using-terraform#heading-5-post-deployment-stuff-->
<!--TODO write something about which and how Gitops deployment models ware implemented (push-base and pull-based)-->
<!--TODO write something about which git branching strategy is used in this repo (probably feature branches and/or forking reporitory....)-->
<!--TODO create github kanban "Project" and write about it on readme-->
<!--TODO Do all of TODO from every workflow and from my notes-->
<!--TODO test does every link works right-->
<!--TODO Make sure that real repo file structure is shown at the README in tree-file structure (probably it's not because I have to at least add images in "/images folder")-->
<!--TODO Fix the typos-->
<!--TODO Add more sections-->
