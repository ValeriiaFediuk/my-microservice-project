# Lesson 9

## Опис проєкту
Мета проєкту — створити кластер Kubernetes у вже існуючій VPC, налаштувати ECR для Docker-образу Django-застосунку та розгорнути застосунок у кластері за допомогою Helm-чарту.

## Основні компоненти:
Кластер Kubernetes через Terraform.
ECR для зберігання Docker-образу Django.
Docker-образ завантажено у ECR.
Helm-чарт із:
Deployment (Django + ConfigMap)
Service (LoadBalancer)
HPA (масштабування 2-6 подів при >70% CPU)
ConfigMap (змінні середовища)

---

## Модулі та їх призначення

### 1. s3-backend
- Створює S3-бакет для зберігання Terraform state.
- Вмикає версіонування S3-бакета.
- Створює таблицю DynamoDB для блокування стейтів.
- Outputs:
  - `s3_bucket_name` – назва бакета.
  - `dynamodb_table_name` – назва таблиці блокування.

### 2. vpc
- Створює VPC з CIDR блоком.
- Додає 3 публічні та 3 приватні підмережі.
- Створює Internet Gateway та NAT Gateway.
- Налаштовує маршрутизацію через Route Tables.
- Outputs:
  - `vpc_id` – ID створеної VPC.
  - `public_subnets` – список ID публічних підмереж.
  - `private_subnets` – список ID приватних підмереж.
  - `internet_gateway_id` – ID Internet Gateway.

### 3. ecr
- Створює ECR репозиторій.
- Автоматичне сканування образів при пуші.
- Outputs:
  - `repository_url` – URL ECR репозиторію.

### 4. eks
- Створює кластер Kubernetes (EKS) у вказаних підмережах.
- Підключає Node Group з EC2 інстансами.
- Outputs:
  - `cluster_name` – назва кластера.
  - `cluster_endpoint` – URL API кластера.
  - `eks_node_role_arn` – ARN ролі для нод.
  - `subnet_ids` – ID підмереж, де розгорнуті ноди.

### 5. rds
- Створює базу даних PostgreSQL (RDS).
- Надає користувача та пароль для підключення.
- Outputs:
  - `db_endpoint` – кінцева точка RDS.
  - `db_name` – назва бази.
  - `db_user` – користувач бази.

---

## Кроки виконання

1. Ініціалізація проєкту та модулів:

```bash
terraform init
```

2. Перевірка планованих змін:

```bash
terraform plan
```

3. Створення інфраструктури:

```bash
terraform apply
```

4. Підключення до EKS:

```bash
aws eks --region eu-central-1 update-kubeconfig --name eks-cluster-fediuk
kubectl get nodes
```

5. Підготовка Docker-образу:

```bash
docker build -t django-app .
aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin <ECR_REPO_URL>
docker tag django-app:latest <ECR_REPO_URL>:latest
docker push <ECR_REPO_URL>:latest
```

6. Розгортання Helm-чарту:

```bash
helm upgrade --install django-app ./charts/django-app -n django --create-namespace
```

7. Перевірка подів і сервісу

```bash
kubectl get pods,svc -n django
```
* Поди мають бути `Running`.
* Service типу `LoadBalancer` з EXTERNAL-IP.
