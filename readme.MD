# Expense DEV Infrastructure

- Make sure infra is created.
- Every resource should have dev in its name, so that it will not overlap with prod resources.

Once infra is setup. We need to configure ingress controller to provide internet access to our expense application.

We are using bastion as our EKS client, so it will have
- K9S
- kubectl
- helm
- aws configure


### RDS Configuration
- Since we are using RDS instead of MySQL image, we need to configure RDS manually, we are creating schema as part of RDS but table and user should be created.
- Make sure MySQL instance allows port no 3306 from bastion

```python
mysql -h expense-dev.czn6yzxlcsiv.us-east-1.rds.amazonaws.com -u root -pExpenseApp1
```

```python
USE transactions;
```

```python
CREATE TABLE IF NOT EXISTS transactions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    amount INT,
    description VARCHAR(255)
);
```

```python
CREATE USER IF NOT EXISTS 'expense'@'%' IDENTIFIED BY 'ExpenseApp@1';
```

```python
GRANT ALL ON transactions.* TO 'expense'@'%';
```

```python
FLUSH PRIVILEGES;
```



### Target group binding

- If we are running frontend using normal user it can't bind the port 80. non root privelege user running container are not able to open system ports which are under 1024.
- So we have to use port no 8080 for frontend. Make sure
    * nginx.conf opens port no 8080 instead of 80.
    * ALB target group health check port should be 8080.
    * frontend service target port should be 8080 instead of 80.


## Ingress Controller
- Login to bastion host and get the kubeconfig of EKS cluster

```python
aws configure
```

```python
aws eks update-kubeconfig --region us-east-1 --name expense-dev
```

```python
kubectl get nodes
```


- Create namespace expense

```python
kubectl create namespace expense
```

- IAM policy

```python
curl -o iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.10.0/docs/install/iam_policy.json
```

- IAM Role created

```python
aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam-policy.json
```

- Create Service account. Replace your account ID.

```python
eksctl create iamserviceaccount \
--cluster=expense-dev \
--namespace=kube-system \
--name=aws-load-balancer-controller \
--attach-policy-arn=arn:aws:iam::816069152585:policy/AWSLoadBalancerControllerIAMPolicy \
--override-existing-serviceaccounts \
--region us-east-1 \
--approve
```

- Install aws load balancer controller drivers through helm.

```python
helm repo add eks https://aws.github.io/eks-charts
```

```python
helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --set clusterName=expense-dev --set serviceAccount.create=true --set serviceAccount.name=aws-load-balancer-controller
```

- Make sure load balancer pods are running

```python
kubectl get pods -n kube-system
NAME                                            READY   STATUS    RESTARTS   AGE
aws-load-balancer-controller-689495d45f-mwmg6   0/1     Running   0          8s
aws-load-balancer-controller-689495d45f-v78wh   0/1     Running   0          8s
aws-node-txwjc                                  2/2     Running   0          5m13s
aws-node-v9d79                                  2/2     Running   0          5m17s
coredns-789f8477df-55j2d                        1/1     Running   0          9m52s
coredns-789f8477df-74j5h                        1/1     Running   0          9m52s
eks-pod-identity-agent-9ngdt                    1/1     Running   0          5m17s
eks-pod-identity-agent-cj98g                    1/1     Running   0          5m17s
kube-proxy-7sgw7                                1/1     Running   0          6m4s
kube-proxy-8zb7z                                1/1     Running   0          6m5s
```