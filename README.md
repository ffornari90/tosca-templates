- [Intro](#intro)
- [Kubernetes](#kubernetes)
  - [Input Variables](#input-variables)
  - [Example input](#example-input)
  - [Requirements](#requirements)

# Intro

TOSCA Templates used by INFN-Cloud PaaS to create instances of supported services.

# Kubernetes

Topology template to create a Kubernetes cluster instance.

## Input Variables

- **admin_token**: Password token for accessing k8s dashboard and grafana dashboard
- **number_of_masters**: Number of VMs for K8s master
- **num_cpus_master**: Number of CPU for K8s master VM
- **mem_size_master**: Memory size for K8s master VM
- **number_of_nodes**: Number of K8s node VMs
- **num_cpus_node**: Number of CPUs for K8s node VM
- **mem_size_node**: Memory size for K8s node VM
- **number_of_nodes_with_gpu**: Number of K8s node VMs with GPU support
- **num_cpus_node_with_gpu**: Number of CPUs for K8s node VM with GPU support
- **mem_size_node_with_gpu**: Memory size for K8s node VM with GPU support
- **num_gpus_node**: Number of GPUs for K8s node with GPU support
- **gpu_model_node**: GPU model
- **enable_gpu**: Flag to enable GPU support (apply to GPU accelerated nodes)

## Example input

The following command creates a Kubernetes cluster with one node with GPU support and another node without GPU.
Notice that you can specify different memory/cpus requirements for nodes with and without GPU.

```sh
orchent depcreate -g ${INFN_CLOUD_GROUP} k8s_cluster.yaml \
'{
  "admin_token": "xyz",
  "number_of_masters": 1,
  "mem_size_master": "8 GB",
  "num_cpus_master": 4,
  "number_of_nodes": 1,
  "mem_size_node": "128 GB",
  "num_cpus_node": 16,
  "number_of_nodes_with_gpu": 1,
  "mem_size_node_with_gpu": "64 GB",
  "num_cpus_node_with_gpu": 8,
  "num_gpus_node": 1,
  "gpu_model_node": "T4",
  "enable_gpu": true,
  "users": [{"os_user_add_to_sudoers": true, "os_user_name": "'${INFN_CLOUD_USERNAME}'", "os_user_ssh_public_key": "'${INFN_CLOUD_PUBLIC_KEY}'"}]
}'
```

> Note: if `number_of_nodes_with_gpu > 0` and is `enable_gpu == false`, no software to enable GPU support (e.g. GPU vendor drivers) will be installed on GPU accelerated nodes, this allows users to customize GPU support.

## Requirements

- [dodas.kubernetes](#https://galaxy.ansible.com/dodas/kubernetes)
- ansible-role-gpu-support (if `enable_gpu == true`)
