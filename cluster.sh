# Load overrides.env if it exists
if [ -f overrides.env ]; then
    echo "Loading environment variables from overrides.env"
    source overrides.env
else
    echo "No overrides.env file found. Using default environment variables."
    echo "You can create an overrides.env from overrides.env.example to set custom environment variables for this cluster."
fi 

# Load common.env if it exists
if [ -f common.env ]; then
    echo "Loading environment variables from common.env"
    source common.env
else
    echo "No common.env file found. Using default environment variables."
fi 

# Support ./cluster.sh create aws, gcp, azure, kind, openshift
# Support ./cluster.sh destroy aws, gcp, azure, kind, openshift
# Support ./cluster.sh info aws, gcp, azure, kind, openshift
# Support ./cluster.sh help
# Support ./cluster.sh allow-ip aws,gcp, azure, kind, openshift one or more IP addresses or CIDR blocks
# Support ./cluster.sh allow-port aws,gcp, azure, kind, openshift one or more ports or port ranges
# 

if [ "$1" == "create" ]; then
    if [ "$2" == "aws" ]; then
        echo "Creating AWS cluster..."
        # Add AWS cluster creation logic here
        # call ./provider/aws/eks.sh to do terraform apply with the appropriate variables (./provider/aws/aws.env) and configuration for AWS
    elif [ "$2" == "gcp" ]; then
        echo "Creating GCP cluster..."
        # Add GCP cluster creation logic here
        # call ./provider/gcp/gke.sh to do terraform apply with the appropriate variables (./provider/gcp/gcp.env) and configuration for GCP
    elif [ "$2" == "azure" ]; then
        echo "Creating Azure cluster..."
        # Add Azure cluster creation logic here
        # call ./provider/azure/aks.sh to do terraform apply with the appropriate variables (./provider/azure/azure.env) and configuration for Azure
    elif [ "$2" == "kind" ]; then
        echo "Creating Kind cluster..."
        # Add Kind cluster creation logic here
        # call ./provider/kind/kind.sh to do simple cluster creation with the appropriate variables (./provider/kind/kind.env) and configuration for Kind
    elif [ "$2" == "openshift" ]; then
        echo "Creating OpenShift cluster..."
        # Add OpenShift cluster creation logic here
        # call ./provider/rosa/openshift.sh to do terraform apply with the appropriate variables (./provider/rosa/rosa.env) and configuration for OpenShift
    else
        echo "Unknown provider: $2"
        exit 1
    fi
elif [ "$1" == "destroy" ]; then
    if [ "$2" == "aws" ]; then
        echo "Destroying AWS cluster..."
        # Add AWS cluster destruction logic here
        # call ./provider/aws/eks.sh to do terraform destroy with the appropriate variables (./provider/aws/aws.env) and configuration for AWS
    elif [ "$2" == "gcp" ]; then
        echo "Destroying GCP cluster..."
        # Add GCP cluster destruction logic here
        # call ./provider/gcp/gke.sh to do terraform destroy with the appropriate variables (./provider/gcp/gcp.env) and configuration for GCP
    elif [ "$2" == "azure" ]; then
        echo "Destroying Azure cluster..."
        # Add Azure cluster destruction logic here
        # call ./provider/azure/aks.sh to do terraform destroy with the appropriate variables (./provider/azure/azure.env) and configuration for Azure
    elif [ "$2" == "kind" ]; then
        echo "Destroying Kind cluster..."
        # Add Kind cluster destruction logic here
        # call ./provider/kind/kind.sh to do simple cluster destruction with the appropriate variables (./provider/kind/kind.env) and configuration for Kind
    elif [ "$2" == "openshift" ]; then
        echo "Destroying OpenShift cluster..."
        # Add OpenShift cluster destruction logic here
        # call ./provider/rosa/openshift.sh to do terraform destroy with the appropriate variables (./provider/rosa/rosa.env) and configuration for OpenShift
    else
        echo "Unknown provider: $2"
        exit 1
    fi
elif [ "$1" == "info" ]; then
    if [ "$2" == "aws" ]; then
        echo "Getting info for AWS cluster..."
        # Add AWS cluster info logic here
    elif [ "$2" == "gcp" ]; then
        echo "Getting info for GCP cluster..."
        # Add GCP cluster info logic here
    elif [ "$2" == "azure" ]; then
        echo "Getting info for Azure cluster..."
        # Add Azure cluster info logic here
    elif [ "$2" == "kind" ]; then
        echo "Getting info for Kind cluster..."
        # Add Kind cluster info logic here
    elif [ "$2" == "openshift" ]; then
        echo "Getting info for OpenShift cluster..."
        # Add OpenShift cluster info logic here
    else
        echo "Unknown provider: $2"
        exit 1
    fi
elif [ "$1" == "allow-ip" ]; then
    if [ "$2" == "aws" ]; then
        echo "Allowing IPs for AWS cluster..."
        # Add AWS allow IP logic here
    elif [ "$2" == "gcp" ]; then
        echo "Allowing IPs for GCP cluster..."
        # Add GCP allow IP logic here
    elif [ "$2" == "azure" ]; then
        echo "Allowing IPs for Azure cluster..."
        # Add Azure allow IP logic here
    elif [ "$2" == "kind" ]; then
        echo "Allowing IPs for Kind cluster..."
        # Add Kind allow IP logic here
    elif [ "$2" == "openshift" ]; then
        echo "Allowing IPs for OpenShift cluster..."
        # Add OpenShift allow IP logic here
    else
        echo "Unknown provider: $2"
        exit 1
    fi
elif [ "$1" == "allow-port" ]; then
    if [ "$2" == "aws" ]; then
        echo "Allowing ports for AWS cluster..."
        # Add AWS allow port logic here
    elif [ "$2" == "gcp" ]; then
        echo "Allowing ports for GCP cluster..."
        # Add GCP allow port logic here
    elif [ "$2" == "azure" ]; then
        echo "Allowing ports for Azure cluster..."
        # Add Azure allow port logic here
    elif [ "$2" == "kind" ]; then
        echo "Allowing ports for Kind cluster..."
        # Add Kind allow port logic here
    elif [ "$2" == "openshift" ]; then
        echo "Allowing ports for OpenShift cluster..."
        # Add OpenShift allow port logic here
    else
        echo "Unknown provider: $2"
        exit 1
    fi
elif [ "$1" == "help" ]; then
    echo "Usage: $0 [command] [provider] [options]"
    echo "Commands:"
    echo "  create [provider] - Create a cluster for the specified provider (aws, gcp, azure, kind, openshift)"
    echo "  destroy [provider] - Destroy the cluster for the specified provider"
    echo "  info [provider] - Get information about the cluster for the specified provider"
    echo "  allow-ip [provider] [IPs] - Allow one or more IP addresses or CIDR blocks for the specified provider"
    echo "  allow-port [provider] [ports] - Allow one or more ports or port ranges for the specified provider" 
    echo "  help - Show this help message"
else
    echo "Unknown command: $1"
    echo "Use '$0 help' for usage information."
    exit 1
fi

