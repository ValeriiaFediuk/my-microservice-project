# Lesson 9

## Опис проєкту
Цей проєкт демонструє розгортання Kubernetes-кластера через Terraform, налаштування ECR, Jenkins pipeline для CI/CD та управління додатками через Argo CD.

---

## 1. Terraform

### 1. Ініціалізація та застосування інфраструктури:

```bash
terraform init
terraform plan
terraform apply
```
### 2. Перевірка ресурсів:
```bash
terraform output
kubectl get ns
kubectl get nodes
kubectl get svc -n django
```

## 2. Jenkins
- URL сервісу:
```bash
kubectl get svc -n jenkins
```
- Jenkinsfile збирає Docker-образ, пушить його в ECR та оновлює Helm-чарт.
- Перевірка job: **Jenkins UI → Job → Console Output.**

## 3. Argo CD
- Порт-форвард для доступу до UI:
```bash
kubectl port-forward svc/argo-cd-argocd-server -n argocd 8080:443
```
- Відкрити у браузері: **https://localhost:8080**
- Логін:**admin**
- Пароль:
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```
- Додати Application:
  - Репозиторій: GitHub
  - Path: **lesson-5/charts/django-app**
  - Branch: **lesson-9**
- Перевірка стану: **Application Synced / Healthy**, podи та service працюють.

## 4. Terraform RDS Module

Цей модуль створює **RDS (PostgreSQL)** інстанс у приватних сабнетах VPC.  
Використовується для розгортання бази даних у AWS.

---

## Приклад використання

```hcl
module "rds" {
  source = "./modules/rds"

  db_name              = "fediuk_rds"
  username             = "valerie"
  password             = "SuperStrongPass123"
  engine               = "postgres"
  engine_version       = "15.8"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  vpc_security_group_ids = ["sg-1234567890abcdef"]
  subnet_ids           = ["subnet-aaa", "subnet-bbb", "subnet-ccc"]

  tags = {
    Environment = "dev"
    Project     = "goit"
  }
}
```

| Назва                    | Тип          | Обов’язкова | Опис                                                                     |
| ------------------------ | ------------ | ----------- | ------------------------------------------------------------------------ |
| `db_name`                | string       | ✅           | Ім'я бази даних, яка створиться при ініціалізації.                       |
| `username`               | string       | ✅           | Ім’я користувача (master user) для підключення до БД.                    |
| `password`               | string       | ✅           | Пароль для master user. Мінімум 8 символів.                              |
| `engine`                 | string       | ❌           | Тип СУБД. За замовчуванням `"postgres"`.                                 |
| `engine_version`         | string       | ❌           | Версія СУБД (наприклад, `"14.9"`, `"15.8"`).                             |
| `instance_class`         | string       | ❌           | Тип EC2 інстансу для RDS (наприклад, `"db.t3.micro"`, `"db.t3.medium"`). |
| `allocated_storage`      | number       | ❌           | Розмір диску у GB.                                                       |
| `vpc_security_group_ids` | list(string) | ✅           | Список Security Groups для доступу до БД.                                |
| `subnet_ids`             | list(string) | ✅           | Сабнети для розміщення RDS. Рекомендовано приватні.                      |
| `tags`                   | map(string)  | ❌           | Теги для ресурсу.                                                        |

## Як змінити конфігурацію БД

1. Змінити тип БД (engine)

- PostgreSQL:
```hcl
engine = "postgres"
engine_version = "15.8"
```

- MySQL:
```hcl
engine = "mysql"
engine_version = "8.0.36"
```
Engine і engine_version повинні відповідати офіційним підтримуваним версіям AWS.

2. Змінити клас інстансу
```hcl
instance_class = "db.t3.micro"   # мінімальний варіант
instance_class = "db.t3.medium"  # більше ресурсів
instance_class = "db.m5.large"   # production-навантаження
```