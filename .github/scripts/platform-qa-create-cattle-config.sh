#!/bin/bash
set -e

cat > cattle-config.yaml <<EOF
rancher:
  host: "${RANCHER_HOST}"
  adminToken: "${RANCHER_ADMIN_TOKEN}"
  cleanup: true
  insecure: true
  clusterName: "${CLUSTER_NAME}"
  adminPassword: "${RANCHER_ADMIN_PASSWORD}"

registryInput:
  name: "${QUAY_REGISTRY_NAME}"
  username: "${QUAY_REGISTRY_USERNAME}"
  password: "${QUAY_REGISTRY_PASSWORD}"

awsCredentials:
  accessKey: "${AWS_ACCESS_KEY}"
  secretKey: "${AWS_SECRET_KEY}"
  defaultRegion: "${AWS_REGION}"

clusterConfig:
  machinePools:
  - machinePoolConfig:
      etcd: true
      controlplane: true
      worker: true
      quantity: 1
      drainBeforeDelete: true
      hostnameLengthLimit: 29
      nodeStartupTimeout: "600s"
      unhealthyNodeTimeout: "300s"
      maxUnhealthy: "2"
      unhealthyRange: "2-4"
  kubernetesVersion: "v1.32.7+k3s1"
  provider: "aws"
  cni: "calico"
  nodeProvider: "ec2"
  hardened: false

awsMachineConfigs:
  region: "${AWS_REGION}"
  awsMachineConfig:
  - roles: ["etcd","controlplane","worker"]
    ami: "${AWS_AMI}"
    instanceType: "${AWS_INSTANCE_TYPE}"
    sshUser: "${AWS_USER}"
    vpcId: "${AWS_VPC_ID}"
    volumeType: "${AWS_VOLUME_TYPE}"
    zone: "${AWS_ZONE_LETTER}"
    retries: "5"
    rootSize: "${AWS_ROOT_SIZE}"
    securityGroup: [${AWS_SECURITY_GROUP_NAMES}]
EOF
