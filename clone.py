import boto3
import logging
import os
import time

logger = logging.getLogger()
logger.setLevel(logging.INFO)
client = boto3.client('rds')

# ENV VARS

db_cluster_identifier = os.environ['DB_CLUSTER_IDENTIFIER']
db_cluster_param = os.environ['DB_CLUSTER_PARAMETER']
db_engine = os.environ['DB_ENGINE']
db_kms_arn = os.environ['DB_KMS_ARN']
db_instance_class = os.environ['DB_INSTANCE_CLASS_TYPE']
db_instance_identifier = os.environ['DB_INSTANCE_IDENTIFIER']
db_subnet_group = os.environ['DB_SUBNET_GROUP']
db_source_cluster_identifier = os.environ['DB_SOURCE_CLUSTER_IDENTIFIER']
security_group = os.environ['SECURITY_GROUP_ID'].split(',')


def clone_db_cluster():
    # Initiate DB Cloning
    response = client.restore_db_cluster_to_point_in_time(
        DBClusterIdentifier=db_cluster_identifier,
        DBClusterParameterGroupName=db_cluster_param,
        DBSubnetGroupName=db_subnet_group,
        KmsKeyId=db_kms_arn,
        RestoreType='copy-on-write',
        SourceDBClusterIdentifier=db_source_cluster_identifier,  # Must be ARN for cross account cloning
        UseLatestRestorableTime=True,
        VpcSecurityGroupIds=security_group,
    )

    logger.info('## CLONE DB CLUSTER')
    logger.info(response)


def create_db_instance():
    # Initiate creating a new DB Instance
    response = client.create_db_instance(
        DBClusterIdentifier=db_cluster_identifier,
        DBInstanceClass=db_instance_class,
        DBInstanceIdentifier=db_instance_identifier,
        DBSubnetGroupName=db_subnet_group,
        Engine=db_engine,
    )

    logger.info('## CREATE DB INSTANCE')
    logger.info(response)


def poll_db_cluster(timeout):
    """Polls the status of DB Cluster

    Arguments:
        timeout {string} -- Time until polling expires
    """
    time_elapsed = 0
    while True:
        response = client.describe_db_clusters(
            DBClusterIdentifier=db_cluster_identifier,
        )

        status = response['DBClusters'][0]['Status']
        logger.info(f"DB Cluster Status: {status} ({time_elapsed} seconds)")
        if status == 'available':
            break

        time.sleep(15)
        time_elapsed = time_elapsed + 15

        if time_elapsed >= int(timeout):
            raise TimeoutError(f"Timeout reached on waiting for DB Cluster: {time_elapsed} seconds elapsed.")


def lambda_handler(event, context):
    db_cluster_timeout = os.environ['DB_CLUSTER_TIMEOUT']
    clone_db_cluster()
    poll_db_cluster(db_cluster_timeout)
    create_db_instance()