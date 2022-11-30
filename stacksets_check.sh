#!/bin/sh
# pipelineを含むスタックセット名一覧を取得
echo pipelineを含むスタックセット名一覧
aws cloudformation list-stack-sets --call-as DELEGATED_ADMIN --query "Summaries[?contains(StackName,\`pipeline\`)].StackSetName" --output table
# pipelineを含むスタックセット名を変数へ格納
sets=$(aws cloudformation list-stack-sets --call-as DELEGATED_ADMIN --query "Summaries[?contains(StackName,\`pipeline\`)].StackSetName" --output text)
# スタックセットごとにインスタンスをカウント
for stack in ${sets[@]}
do
echo "[${stack}]: スタックセットのステータス"
aws cloudformation list-stack-set-operations --stack-set-name ${stack} --call-as DELEGATED_ADMIN --query "Summaries[0].{OperationID: OperationID,Action: Action,Status: Status,CreationTimeStamp: CreationTimeStamp,EndTimeStamp: EndTimeStamp}" --output table
echo "[${stack}]: スタックインスタンスの数 " $(aws cloudformation list-stack-instances --stack-set-name ${stack} --call-as DELEGATED_ADMIN --query "length(Summaries[])")
# ID,Region,Status,アカウントIDを出力
aws cloudformation list-stack-instances --stack-set-name ${stack} --call-as DELEGATED_ADMIN --query "Summaries[].{ID: StackSetId,Region: Region,Status: StackInstanceStatus.DetailedStatus}" --output table
done