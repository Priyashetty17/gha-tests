name: "Get Kubernetes Version"
description: "Returns the recommended Kubernetes version for a given Rancher version"
inputs:
  rancher_version:
    description: "Short Rancher version (e.g., 2.12)"
    required: true
outputs:
  kubernetes_version:
    description: "Recommended Kubernetes version for this Rancher version"
runs:
  using: "composite"
  steps:
    - name: Map Rancher version to K8s version
      shell: bash
      run: |
        SHORT_VERSION="${{ inputs.rancher_version }}"
        case "$SHORT_VERSION" in
          "2.9") K8S_VERSION="v1.30.14+k3s1" ;;
          "2.10") K8S_VERSION="v1.31.11+k3s1" ;;
          "2.11"|"2.12") K8S_VERSION="v1.32.7+k3s1" ;;
          "2.13") K8S_VERSION="v1.33.3+k3s1" ;;
          *) K8S_VERSION="v1.33.3+k3s1" ;; 
        esac
        echo "Selected K8s version for Rancher $SHORT_VERSION: $K8S_VERSION"
        echo "kubernetes_version=$K8S_VERSION" >> $GITHUB_OUTPUT
