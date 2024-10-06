set -U SU_CLASSIC_ECR_HOST "op://SumUp/Infra variables/Classic ECR Hostname"
set -U SU_PORTIER_DEV_DB_HOST "op://SumUp/Infra variables/Theta Portier RDS Host"
set -U SU_PORTIER_STAGE_DB_HOST "op://SumUp/Infra variables/Stage Portier RDS Host"
set -U SU_PORTIER_LIVE_DB_HOST "op://SumUp/Infra variables/Live Portier RDS Host"
set -U SU_PLATFORM_LIVE_DB_HOST "op://SumUp/Infra variables/Live Platform DB RDS Host"
set -U SU_PLATFORM_THETA_DB_HOST "op://SumUp/Infra variables/Theta Platform DB RDS Host"


# alias cecr="login_ecr -p sumup-classic-sso-acl -h $(op read $SU_CLASSIC_ECR_HOST)"
alias csso="aws_sso_login -p sumup-classic-sso-acl"
alias tsso="aws_sso_login -p sumup-dbaccess-theta"
