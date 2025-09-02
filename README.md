# Terraform Lesson 5 - AWS Infrastructure

## Опис проєкту
Цей проєкт демонструє використання Terraform для створення інфраструктури на AWS з модульним підходом. Інфраструктура включає:
1. Зберігання Terraform state у S3 з блокуванням через DynamoDB.
2. Мережеву інфраструктуру (VPC) з публічними та приватними підмережами, Internet Gateway і NAT Gateway.
3. ECR (Elastic Container Registry) для зберігання Docker-образів.

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

---

## Налаштування бекенду Terraform
```hcl
terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket-fediuk-001"
    key            = "lesson-5/terraform.tfstate"   
    region         = "eu-central-1"                    
    dynamodb_table = "terraform-locks"              
    encrypt        = true                           
  }
}
```
---

## Команди для роботи з Terraform

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

4. Видалення інфраструктури:

```bash
terraform destroy
```

5. Перегляд вихідних даних:

```bash
terraform output
```
