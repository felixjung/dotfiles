set -U SU_CLASSIC_ECR_HOST "op://SumUp/Infra variables/Classic ECR Hostname"
set -U SU_PORTIER_DEV_DB_HOST "op://SumUp/Infra variables/Theta Portier RDS Host"
set -U SU_PORTIER_STAGE_DB_HOST "op://SumUp/Infra variables/Stage Portier RDS Host"
set -U SU_PORTIER_LIVE_DB_HOST "op://SumUp/Infra variables/Live Portier RDS Host"


alias cecr="op run -- login_ecr -p sumup-classic-sso-acl -h $SU_CLASSIC_ECR_HOST"
alias casso="aws_sso_login -p sumup-classic-sso-acl"
