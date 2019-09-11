kubectl completion zsh > "$ZFUNCTIONS/_kubectl"
###
# Setting up minikube
###

# We use hyperkit as hypervisor
minikube config set vm-driver hyperkit

# As per the Hombrew formula we need to provide root access to
# the driver.
sudo chown root:wheel $(brew --prefix)/bin/docker-machine-driver-hyperkit
sudo chmod u+s $(brew --prefix)/bin/docker-machine-driver-hyperkit
