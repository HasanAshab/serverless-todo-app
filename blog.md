# Building a Serverless Todo App on AWS with Terraform and GitHub Actions

When I started this project, I didn’t want to just build *another* todo app. We’ve all seen those before. My goal was different: **build something simple on the outside, but production-ready on the inside** — something that shows what a DevOps engineer actually does.

![Serverless Todo App](https://raw.githubusercontent.com/HasanAshab/serverless-todo-app/main/static/images/project.jpg)

That’s how this **Serverless Todo App** came to life. A lightweight frontend for users, but behind it sits a complete AWS setup: serverless compute, Infrastructure as Code, and automated CI/CD pipelines.


## 🌱 Why Serverless?

The choice was clear. For small apps (and honestly, for many startups too), serverless hits the sweet spot:

* Perfect for apps with unpredictable traffic (like side projects, MVPs, or apps with spiky usage)
* Scales up (and down to zero) automatically
* Pay only for what you use (almost zero cost when idle)
* High availability by default

Basically: if your customer base is uncertain or your workload isn’t steady, serverless is the go-to choice.


## 🏗️ The Architecture

I followed a classic three-tier approach — but all serverless:

**Frontend**

* React app hosted in S3
* CloudFront for fast, global delivery
* OAC so no one can hit S3 directly

**Backend**

* API Gateway to handle requests
* Lambda functions for each CRUD operation
* IAM roles with the bare minimum permissions

**Database**

* DynamoDB table with `id` as hash key
* Pay-per-request billing — no wasted capacity

Here’s a sketch of it all working together:

![Serverless Architecture](https://raw.githubusercontent.com/HasanAshab/serverless-todo-app/main/infra/static/images/architecture.png)


## 🔧 Infrastructure as Code with Terraform

Instead of clicking around the AWS console, everything is defined in Terraform. I broke it into **modules**:

* `frontend/` → S3 + CloudFront setup
* `backend/` → API Gateway + Lambda functions + IAM
* `dynamodb/` → Key-value table

This modular approach made it easy to spin up dev, staging, and prod environments. Just change a `tfvars` file, and Terraform does the rest.

## ⚙️ CI/CD Pipelines

The real DevOps flavor comes here. I used **GitHub Actions** to automate deployments:

* **Frontend pipeline** → Build React app, push to S3, invalidate CloudFront
  ![Frontend CI/CD](https://raw.githubusercontent.com/HasanAshab/serverless-todo-app/main/static/images/cicd/frontend.png)
* **Backend pipeline** → Package & deploy Lambda functions
  ![Backend CI/CD](https://raw.githubusercontent.com/HasanAshab/serverless-todo-app/main/static/images/cicd/backend.png)
* **Infra pipeline** → Terraform plan/apply with drift detection
  ![Terraform CI/CD](https://raw.githubusercontent.com/HasanAshab/serverless-todo-app/main/infra/static/images/cicd.png)

Production deployments always require **manual approval** — I wanted it to feel realistic, not reckless.


## 🔍 Monitoring & Security

A few non-negotiables I baked in:

* CloudWatch metrics and alerts for errors and latency
* Terraform drift detection (to catch sneaky manual console changes)
* IAM least privilege for every Lambda
* CloudFront enforcing HTTPS and hiding the S3 bucket

Nothing fancy, just the basics done right.

## 💸 Cost-Friendly by Default

Since it’s serverless:

* Lambda only bills on execution
* DynamoDB scales automatically
* CloudFront caching reduces backend hits

In idle periods, the whole system costs almost nothing.

---

## 🛠️ What I Learned

* **Terraform modules** are a lifesaver for reusability
* **Separate pipelines** keep infra, backend, and frontend independent
* **Serverless debugging** is trickier than traditional apps (logs are your best friend)
* **Cold starts** exist, but caching and design can reduce the pain


## 🚀 Why This Project Matters

At first glance, it’s “just a todo app.” But under the hood, it’s a real-world **DevOps case study**:

* Infrastructure as Code
* Automated CI/CD
* Secure, scalable, cost-efficient design
* Production-ready practices like monitoring, drift detection, and multi-env setups

## 📂 Code & Repo

You can check out the full implementation here:
👉 [Serverless Todo App on GitHub](https://github.com/HasanAshab/serverless-todo-app)


### Final Thought

I built this project to show that even something simple can demonstrate **serious DevOps skills** when designed with the right mindset.

---
## 📬 Contact

If you’d like to connect, collaborate, or discuss DevOps, feel free to reach out:

* **Website**: [hasan-ashab](https://hasan-ashab.vercel.app/)
* **GitHub**: [github.com/HasanAshab](https://github.com/HasanAshab/)
* **LinkedIn**: [linkedin.com/in/hasan-ashab](https://linkedin.com/in/hasan-ashab/)
