#!/bin/bash

# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# In order to not expose this project to the internet with a Cloud Load Balancer
# we are instead port-forwarding to the node and exposing the pod port

# "---------------------------------------------------------"
# "-                                                       -"
# "- port-forward to pyrios-ui pod of the cloud GKE cluster-"
# "-                                                       -"
# "---------------------------------------------------------"

set -o errexit
set -o nounset
set -o pipefail

PROJECT_ROOT=$(dirname "${BASH_SOURCE[0]}")/../

source "$PROJECT_ROOT"k8s.env

echo "kubectl uses ${STAGING_CLOUD_GKE_CONTEXT}"
kubectl config use-context "${STAGING_CLOUD_GKE_CONTEXT}"
# look up the pyrios-ui pod id by the label app=pyrios-ui
POD_ID=$(kubectl get pods -l app=pyrios-ui -o jsonpath='{.items[*].metadata.name}')
# set up port forwarding from the laptop/desktop to the pyrios-ui pod
# so that we can talk to pyrios
kubectl port-forward "${POD_ID}" 8080:8080
