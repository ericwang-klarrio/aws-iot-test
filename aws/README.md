

## Use Kubernetes UI

### AWS credential file

Put your aws access id and secret id in you aws credential file(~/.aws/credentials).

```
[apac]
aws_access_key_id = XXXXXXXXXXXX
aws_secret_access_key = xxxxxxxxxxxxxxxxxxxxxxxxx
```

Then Update `AWS_PROFILE` in the `~/.bashrc` file.

```
export AWS_PROFILE=apac
```

Source the `bashrc` file

```
user@host:~$ source ~/.bashrc
```

### Update eks config

Make sure that the aws cli version is equal or over `1.16.161`.

Run command below on your laptop to update eks config file.

```
user@host:~$ AWS_DEFAULT_REGION=ap-southeast-2 aws eks update-kubeconfig --name test-eks-YtlqUi7K
```

### Get kubernetes admin user service account token

```
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')
```

### Start Kubernetes UI proxy

```
kubectl proxy &
```

### Open UI

You can access the UI at:

http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/

Input the token you get above and you are able to login to the Kubernetes UI.
