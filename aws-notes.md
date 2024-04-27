# AWS Solutions Architect Notes

Notes from video course focused on the Certified Solutions Architect Associate
exam.

NEXT: 287 (Section 25)

To see which services are available in a given region, visit:
https://aws.amazon.com/about-aws/global-infrastructure/regional-product-services/

## IAM: Identity and Access Management

The user you use to sign into AWS initially is the root user, so should only
use that moving forward when absolutely necessary.

Groups can only contain users (not other groups).

Best practice is that all users are members of at least one group, thought this
is not strictly necessary.

Create an admin user, add to a new group "admin", and give that group the
"AdministratorAccess" policy.

The download CSV available after creating includes the credentials created.

Can create an alias for account, which then comes with a custom logic for that
account.

**Account Settings** This is where you set up security policies, like
requiring MFA and password restrictions.

Setting it up per user is from the user drop-down for your account.

CLI keys are under IAM, then select your user. Don't ever create CLI
credentials using the root account.

**CloudShell** Alternative to CLI which works from the web console.

**Roles** are permissions for AWS services to run on your behalf.

**IAM Credentials Report** (account-level) Show things like when password was
last change, MFA enabled, etc. for all users in the account.

**IAM Access Report** (user-level) Under the IAM Users after selecting an
individual user. Allows you to see when permissions were last used (good audit
for what to remove).

IAM Conditions: restrict policies based upon conditions, like deny IP ranges.
- can also use for something like restricting storage to only EU regions
- can configure it based upon tags
- can force MFA for certain actions

IAM Roles vs Resource Based Policy
- when assuming a role, you give up old permissions and take on new ones
- with policy, you don't give up your role permissions

IAM Permission Boundaries
- allow you to set maximum permissions an IAM entity can get
- supported for users and roles, not groups
- Similar to organization SCP, prevents giving access in identity-based perms
- use cases:
  - delegate responsibilities to non-administrators, like creating users
  - allow developers to self-assign policies without allowing privilege escalation
  - useful for restricting one specific user

## EC2: Elastic Compute Cloud

EC2 includes EBS, ELB, and ASG as well.

EC2 User Data - automated tasks that run once on first start-up. Runs a `root`
user.

(t2.micro is part of free tier up to 750 hours/month) [BTW, 31 * 24 = 744]

AMI (Amazon Machine Image)

When you launch an image from the console, it will indicate which images are
"free tier" available. The simple linux one is.

When you create an instance, you may need to create a key pair. Use RSA. It's
what you'll use to connect to the instance from SSH.

If you tag with "Name", that will be used in the listing in the console.

Public IPv4 will change each time you stop and start an instance.

Instance Types: https://aws.amazon.com/ec2/instance-types/
  m5.2xlarge -> m: instance class; 5: generation (improves over time); 2xlarge:
                size within instance class
- General Purpose ("t" or "m"): good for web servers and code repositories.
- Compute Optimized ("c"): for high performance computing (batch loads, media
  transcoding, machine learning, gaming server, etc.) [minecraft?]
- Memory Optimized ("r" or "x"): high performance in memory, like DBs and
  caches. ["r" for RAM]
- Storage Optimized ("i" or "d"): high sequential read|write to local storage.
  OLTP, DBs, cache, data warehousing, file systems.

https://instances.vantage.sh/ for comparing instance costs and specs. (ec2instances.info)

Security Groups: the firewall for your instance, e.g., only open port 22 to my
home IP address to prevent others from accessing.
- limited to a region or VPC combination.
- lives outside instance, so it doesn't even see traffic that's not allowed.
- if you timeout talking to instance, it's probably a Security Group issue.
  Connection refused, on the other hand, means your application is getting the
  request and not responding as desired.
- by default, all inbound blocked, all outbound open.

Best Practice: Maintain a separate security group just for SSH access.

Important ports to remember: 22 SSH/SFTP, 21 FTP, 80 HTTP, 443 HTTPS, 3389
RDP (MSWin remote access)

To SSH, grab public IPv4 address from console. Grab `pem` file as well.
`chmod 0400 <path-to.pem>` (otherwise will get security warning)
`ssh -i <path-to.pem> ec2-user@<ip-addr>`

**EC2 Instance Connect** allows you to get a shell using the web console.
Still requires port 22 to be open.

Don't ever add your AWS credentials to an instance, e.g., if you wanted to SSH
in and run `aws-cli` commands. Should be using IAM Roles instead.

EC2 purchase options:
- On-demand. Billed per second. Highest cost, but no up-front payment. For
  short-term and un-interrupted workloads where you cannot predict app
  behavior.
- Reserved, minimum 1 year. Includes "reserved instance" and "convertible
  reserved instances", the latter allows for flexible instances. Up to 75%
  cheaper than on-demand, bigger discount for 3-year commitment. Reserves
  specific instance type. Best for steady-state (like DB). Convertible allows
  you to change instance types within committed time-frame.
- Spot Instances: like on-demand, but less reliable. Cheapest, but price
  changes over time, and you can lose it if cost goes over your threshold.
  Only use for resilient workloads, like batch jobs, distributed workloads,
  like batch jobs, distributed workloads, jobs with flexible start/end times.
  2-minute grace period. You have to cancel spot requests before terminating
  instances.
- Dedicated Host: reserves entire physical server. This is for compliance
  requirements and server-bound license restrictions. More expensive and
  require 3-year commitment.
- Dedicated Instances: reserved, but could still be sharing hardware.

**Spot Fleet** Can include spot and on-demand, configured to minimize cost to
address compute needs.

**Elastic IP** Is a set IP address that you can use, limited to 5 per account.
Since, otherwise, IP changes with each instance. Have to pay for this.
- Best practice, avoid using this. Better to register DNS and use the random
  IP AWS provides. Or load balancer.

**Placement Group** gives control over EC2 instance strategy. This is a
configuration concept and does not cost in and of itself.
- Cluster: low-latency group in single AZ. 10 Gbps bandwidth between
  instances.
- Spread: spread instances across underlying hardware, max 7 per AZ. Use for
  critical applications. Reduced risk of simultaneous hardware failure.
- Partition: spread across partitions (racks) within AZ, can be 100s per
  group. (Hadoop, Kafka, Cassandra, etc.) Instances can get access to
  partition meta-data.

**Elastic Network Interface [ENI]** Logical component in VPC that represent a
virtual network card. Bound to specific AZ. Gives control over private IPv4s.
- Can be created and added to instances on the fly.
- Can be used for a quick network failover.

**EC2 Hibernate** EBS is kept intact in next start. RAM is preserved (up to
150GB), so instance boot is much faster.
- Only supported by certain types ("c", "m", and "r")
- Root volume must be encrypted EBS.
- Only for on-demand and reserved instances.
- Can only hibernate up to 60 days.
- in example, shows that `uptime` is relative to initial time, not restart.

**EC2 Nitro** New underlying platform for EC2.
- Better performance (max 64k IOPS, vs 32k on non-Nitro)
- Includes most newer instance types (5s or up in many cases)
[IOPS I/O operations per second]

vCPU: represents the number of threads * number of cores allocated in a VM.
- Can customize if you need more RAM but not the default number of CPUs (to
  help maintain costs)
- Or, if you want just 1 CPU per core for high-performance computing (HPC)
  workloads.

Capacity Reservations: Have a manual or planned end date, but not tied into
1-3 year commitment. Allow for faster instances, but cheaper than reserved
types.

## EBS: Elastic Block Store

Like a virtual UBS stick. Can only be mounted to one instance in an AZ at a
time, but can attach multiple EBSs to a single instance.
- Free tier includes 30GB of storage per month (SSD or magnetic).
- Uses network to communicate, so will be some latency versus straight to disk.
- Have to use snapshots to move across AZs.
- Have to provision GB and IOPS in advance.

Delete on Termination. Enabled by default on root, disabled for others, but
can change.

Snapshots. Not necessary to detach before creating, but good idea.

Types:
- "gp": General purpose SSD
- "io": highest-performance SSD
- "st": low-cost HDD for frequent access, throughput-intensive workflows
- "sc": lowest-cost HDD for less frequent access.
(only "gp" and "io" can be used as boot volumes)

Can adjust IOPS and storage capacity independently with these types.

Use Provisioned IOPS if you need more that 16,000 IOPS. io2 can get up to 64k
IOPS.

io1/io2 support EBS Multi-Attach, all with read/write access. Good for high
availability (like Teradata). Applications have to manage concurrent writes.
Have to use cluster-aware file system.

Encryption: leverages KMS (AES-256)
- Copying an unencrypted volume does allow for encryption.

**EC2 Instance Store** high-performance disk attached to instance.
- Better I/O performance, but still ephemeral.

## EFS: Elastic File System

Works across AZs. Scalable, but about 3x cost of "gp". Pay per use.
- Uses NFSv4.1 protocol for mounting. Only works with linux systems.
- Have to use Security Groups to access, using an "NFS" rule.

Performance mode (set at creation time)
- General purpose: latency-sensitive, like web server or CMS
- Max I/O: higher latency, but highly parallel (big data, media processing)
Throughput mode: bursting or provisioned modes
Storage tiers (life-cycle, move after n days)
- standard: for frequently accessed files
- EFS-IA (infrequent access): lower price to store, but cost to retrieve

Have to install `amazon-efs-utils` to mount on an instance.

## AMI: Amazon Machine Image

Build for a specific region, though can be copied. Give faster boot times,
since most necessary dependencies can be pre-packaged.

There are vendors that sell AMIs too.

## ELB: Elastic Load Balancing

Managed load balancer, so AWS takes care of upgrades, maintenance, etc. Can be
public or private.

Instance has to respond to port and route for health checks, responding with
200 if OK.

Types
- CLB: Classic Load Balancer, deprecated. (doesn't support IPv6)
- ALB: Application Load Balancer, supports HTTP, HTTPS, WebSocket.
- NLB: Network Load Balancer, supports TCP, TLS, UDP.
- GWLB: Gateway Load Balancer, layer 3 (network layer), IP Protocol.

Security: ELB will be open to 80/443, but instance will only be open to ELB.

ALB. Layer 7 load balancer, for HTTP traffic. Can route to HTTPS from HTTP at
load balancer.
- Can route based upon URL path, URL hostname (x.company.com vs.
  b.company.com), and even by query parameters.
- Greater for micro services and container-based (Docker, ECS)
- Target Groups:
  - EC2 instances, including Auto Scaling Groups
  - ECS tasks
  - Lambda functions, translated to JSON events
  - private IP addresses (e.g., on-prem).
- Get a fixed DNS name like XXX.region.elb.amazonaws.com
- Servers don't see IP of client directly, it's in `X-Forwarded-For` header.

NLB. Layer 4, TCP/UDP traffic. Better latency than ALB (~100ms versus ~400ms)
- Has one static IP per AZ, and supports assigning Elastic IP.
- Not included in free tier
- Target Groups:
  - EC2 instances
  - private IP addresses
  - An ALB (like if you want the fixed IP feature)
- Security group for instances have to accept traffic from anywhere, because
  this balancer in just forwarding on the request with no header
  modifications.

Gateway Load Balancer: to manage 3rd party appliances via AWS.
- Works at level of IP packets. GENEVE protocol on port 6081.

Sticky Sessions / Session Affinity: when client is redirected back to same
instance.
- uses cookies to track, application-based or duration-based.
  - Cannot use "AWSALB~" in cookie name
- works with ALB (and Classic)
- Edit the attributes on the Target Group.

Cross-Zone Load Balancing, will send evenly across instances, even if the
number of instances is not even between zones.
- Without this, the balance would be even between zones, but then would be
  imbalanced after that if instances spread that way.
- Always on for ALB, and you don't pay for inter AZ data
- With NLB, have to pay to enable.

SSL: Secure Sockets Layer
TLS: Transport Layer Security
Although most are using TLS now, colloquially still referred to as "SSL".
ACM: AWS Certificate Manager (where the X.509 certs are managed)

Typical that SSL used between user and load balancer, then HTTP over private
VPC to the individual instances.

SNI: Server Name Indication, clients can specify the hostname they reach
- Addresses how to load multiple certs on a single server.
- Only works with ALB and NLB (and CloudFront)

Deregistration Delay (Connection Draining) - allowing time for in-flight
request to complete before deregistering an instance.

## ASG: Auto Scaling Groups

- Can scale based on CloudWatch alarms
- Can even push metric into CloudWatch using PutMetric API
- "Launch Template" is the newer approach to configuring.
- ASGs are free, just paying for instances.

Dynamic Scaling Policies
- Target Tracking, easiest to set up, like targeting 40% CPU on all instances
- Simple / Step Scaling, like a CPU threshold add or remove instances.
- Scheduled Actions, because you know when load spikes.
- Predictive Scaling, so AWS uses historical load to guess when to scale.
  Driven my machine learning.

Good metrics:
- CPU averages across instances.
- Request counts per target
- Average network in / out (when network bound)

Scaling Cooldown, default 300 seconds, so not autoscaling will happen during
this time to allow for things to settle.
- use a ready-to-use AMI to reduce the cooldown time needed

Default termination policy
- first, select AZ with most instances
- then, delete one with oldest launch config

Lifecycle Hooks, can set additional measures of when an instance is ready or
terminating.

## RDS: Relational Database Service

Includes PostgreSQL, MySQL, MariaDB, Oracle, Microsoft SQL Server, and Aurora

RDS is a managed service, so automated provisioning and OS patching. But,
cannot SSH into them. Storage backed by EBS. 20GB minimum.

Daily full backups, and transaction logs backed up every 5 minutes. 7-day
retention default, but up to 35 days.

DB snapshots are manually triggered by user and can be kept as long as you
want.

Scales automatically when running out of space. Have to set a "Maximum Storage
Threshold" to prevent this from getting out of hand.

Up to 5 read replicas, in same AZ, cross AZs, or cross regions. Async,
eventually consistent replication. Can be promoted to main if needed to stand
as independent DB.
- If replica is in the same region, you don't pay network fee for data
  transfer, since it's a managed service. (Across regions costs $$$)

Multi AZ (disaster recovery). Synchronous replication across zones or region,
with single DNS that automatically fails over to stand-by in case of failure
of the master. Not useful for scaling.
- No manual intervention required for this to work.

Changing from single to multi-AZ is a 0-downtime operation, using a snapshot.

Can use a t2.micro with gp2 SSD to stay in free tier.

The estimated monthly cost will be listed when creating.

Security - Encryption
- At rest encryption: Can set at creation time, but if not set for master
  cannot be applied to read replicas.
- In-flight requires a certificate to encrypt data during communication.
  To enforce:
  - Postgres -> `rds.force_ssl=1` in AWS RDS Console Parameter Groups
  - MySQL -> `GRANT USAGE ON *.* TO 'mysqluser'@'% REQUIRE SSL;`
- Can copy an unencrypted snapshot into an encrypted one. Restoring this would
  enable encryption if not set initially.

Should only expose DB within private subnet, using security groups.

Can use IAM-based auth to login for PostgreSQL and MySQL. Uses token with a
15-minute lifespan.
- Allows you to use IAM instead of DB users for security.

## Aurora

Compatible with PostgreSQL and MySQL. Optimized, so 5x performance over MySQL
on RDS and 3x performance over PostgreSQL RDS.
- Automatically grows, starting at 10GB and up to 128TB.
- Up to 15 read replicas (vs. 5 RDS), with faster replication and failover.
- 20% more expensive

Stores 6 copies of your data across 3 AZs. Needs 4 of 6 to write, 3 of 6 to
read. Self-healing peer-to-peer healing.

Only one instance ("master") takes writes, with <30s failover.

Can set up auto-scaling for read replicas. Load balance is at connection level
(not statement)

Backtrack: restores data at any point in time without using backups.

Security is same as RDS

Can defined a custom endpoint which accesses just some of the read replicas,
for example if some of them are beefier machines. General, default read
endpoint is not used together with custom, but instead each use-case uses a
custom endpoint.

Serverless: when you have infrequent, intermittent, or unpredictable
workloads. No capacity planning needed. You pay per second (and can be cheaper
as a result).

Multi-Master: when you want HA (high availability) with immediate failover.
Every node does R/W.

Global: multi-region (up to 5 secondary, read-only). Up to 16 replicas per
region.
- RTO (Recover Time Objective) of <1min to fail over to another region.

Machine Learning: Aurora has integration with SageMaker (any ML model) and
Comprehend (for sentiment analysis)

## ElastiCache

Managed Redis or Memcached. Helps reduce load off DBs with heavy reads.
- Using ElastiCache does involve heavy code changes, since you are responsible
  for managing hitting the cache before hitting the DB and cache invalidation.
- Useful for storing user sessions in stateless apps.

Redis: multi-AZ with auto-failover, read replicas to scale reads. Has data
durability (with AOF persistence). Backup and restore features.

Memcached: multi-node for partitioning data (sharding). No replication,
persistence, backup, or restore.

Security: Does not support IAM, so policies are only used for AWS API-level
security.
- Redis AUTH available as extra level of security.
- Memcached supports SASL

Patterns:
- Lazy Loading: read data is caches and can become stale
- Write Through: adds or updates when written to DB
- Session Store: temporary, TTL features

Use cases
- Redis: classic is gaming leaderboard, using sorted sets to guarantee
uniqueness and ordering

RDS Databases ports:
- PostgreSQL: 5432
- MySQL/MariaDB: 3306
- Oracle RDS: 1521
- MSSQL Server: 1433

## Route 53

DNS:
- Domain Registrar: Amazon Route 53, GoDaddy, etc.
- DNS Records: A, AAAA, CNAME
- Zone File: contains DNS records
- Name Server: resolves DNS queries (authoritative or non-authoritative)
- Top Level Domain (TLD): .com, .gov, .org, ...
- Second Level Domain (SLD): amazon.com, google.com, ...
- Root DNS Server, managed by ICANN (routes to `.com`)
- TLD DNS Server, managed by IANA (branch of ICANN) (i.e., where in `.com` is
  the address?)
- SLD DNS Server, managed by domain registrar (e.g., Amazon Registrar)

Route 53 allows you to update the DNS records. "Authoritative DNS"
- Also a Domain Registrar
- Can check the health of your resources
- only AWS service with 100% SLA
- "53" because that's the traditional DNS port

Record Types:
- A: maps to IPv4
- AAAA: maps to IPv6
- CNAME: hostname to other hostname, target must be A/AAAA.
  - Cannot create to top node (Zone Apex). e.g., can't do "example.com" only
    "www.example.com"
- NS: Name Servers for the Hosted Zone, controls how traffic routed to domain.

Hosted Zone: container for records defining subdomain routes.
- Public Hosted Zones, open internet access to subdomain.
- Private Hosted Zones, route limited to VPCs ("private.example.internal")
- $0.50/month per hosted zone

TTL: on DNS record. Longer has risk of going stale, but shorter is $$$
- works for every record except Alias
- If you are planning a change, can set a low TTL for a day or so, let clients
  adjust, then set back to a high TTL once change is complete.

CNAME vs Alias
- CNAME doesn't work for root domain, Alias can
- Aliases are free of charge and have native health check
- Aliases always A/AAAA, and cannot set TTL
- Alias automatically changes resource IP address based upon AWS allocations

Alias:
- include ELB, CloudFront Distributions, API Gateway, Elastic Beanstalk,
  S3 Websites, VPC Interface Endpoints, Global Acelerator, Route 53 same zone
  - Cannot use Alias for an EC2 DNS name

Routing Policies:
- Support for Simple, Weighted, Failover, Latency based, Geolocation,
  Multi-Value Answer, Geoproximity (using Route 53 Traffic Flow)
- Simple: single resource. If multiple values in record, random is chosen
  (client gets the list and chooses one)
  - Cannot be associated to a Health Check
- Weighted: control % of requests going to each resource, allows Health Checks.
  - Set weight to 0 to pull instance out of balancer
- Latency: should end up being the closest instance, allows Health Checks.
  - You have to indicated the region, AWS doesn't currently inspect this
- Geolocation: based upon user location.
  - Should have default in case there's no match.
  - Can be used for localization too
- Geoproximity: based upon users and resources, based upon 'bias' (-99 to 99)
  - Can specify latitude and longitude for non-AWS resources
- Multi-Value: up to 8 health records per query, up to client to select one.
  - Not a substitute for ELB

Health Checks: mainly for public resources
- Types:
  - monitor a single endpoint
    - 15 global checkers, default threshold of 3 OK is healthy (>18%)
    - Can set interval, 30 sec default, setting lower costs more money
    - 2xx and 3xx responses are healthy
    - Can parse text in first 5120 bytes of response to set pass/fail
    - have to open to Route 53 servers (documented online)
  - monitor other health checks (Calculated Health Checks)
    - combine checks with OR, AND, or NOT
    - monitor up to 256 child health checks
  - monitor CloudWatch Alarms (e.g., throttles in DynamoDB, alarms on RDS)
    - Can be used to monitor private (behind VPC) resources with alarms

Failover: Active-Passive
- have to use a Health Check to failover from primary to secondary

Traffic Flow: Visual editor for configuration, especially helpful for
approaches like Geoproximity. Includes a map to show how it will affect flow.
- $50/month just to create.

Domain registrars: Will need to update Nameservers with the registrar to point
at the Hosted Zone details from AWS.

## Class Solutions Architecture Discussions

Well Architected Application, 5 pillars: costs, performance, reliability,
security, operational excellence.

Stateless Web App: WhatIsTheTime.com
- Don't need a DB, can scale vertically and horizontally

Stateful Web App: MyClothes.com
- Need to maintain a shopping cart. Options:
  - Stickiness in ELB?
  - Stateful cookies (containing shopping cart)? (heavier payloads up to 4KB, security
    risks)
  - session_id and store cart in ElastiCache (or DynamoDB)
- Storing user info in a DB (RDS)

Shared Storage: MyWordPress.com
- Using EFS to share common storage between redundant instances (vs. EBS)
- Could use Aurora for Multi-AZ

Instantiating Quickly
- EC2 Instances:
  - Golden AMI: all OS dependencies installed ahead of time for faster startup
  - Bootstrap using User Data (for dynamic config)
  - Hybrid of these two is Elastic Beanstalk
- RDS and EBS: use snapshots to speed up

## Elastic Beanstalk

Developer-centric view of AWS deployment. Bundles configuration of multiple
services, so you pay for those services when they launch.

Supports a lot of language environments, as well as docker and custom.

Components:
- Application: collection of Beanstalk components (environments, version,
  config, ...)
- Application Version: an iteration of your app
- Environment: Collection of AWS resources. Can has multiple (dev, test prod)
  - Tiers: Web Server Environment Tier (ELB-centered) & Worker Environment
    Tier (SQS-centered)

## S3

Allows storage of objects (files) into "buckets" (directories).
"key" is full path to file in bucket, made up of "prefix" and "object name"

Bucket names must be globally unique. Defined at region level. But S3 console
is global.

Naming conventions: No uppercase, no underscore, 3-63 characters long, not an
IP, start with lowercase letter or number

Max size: 5TB. Can only upload 5GB at time, so have to use multi-part upload
to hit TB.

Versioning: overwrites existing files, but keeps history.
- Version ID will be null if uploaded when versioning not enabled.
- When you delete, it only adds a marker, and you can see older versions when
  "List versions" enabled.
  - if you delete from the versioned view, it will be permanent

Encryption:
- SSE-S3: encrypts S3 objects using keys handled and managed by AWS (AES-256)
  - must set header "x-amz-server-side-encryption":"AES256"
- SSE-KMS: leverage AWS Key Management Service
  - advantage of user control over keys and audit trail
  - must set header "x-amz-server-side-encryption":"aws:kms"
  - "CMK": Customer Master Key
- SSE-C: manage your own keys
  - Amazon doesn't store keys, so have to use HTTPS to transfer, including
    data key in header.
- Client Side Encryption
  - There is "S3 Encryption Client" from AWS that can be used.

Security:
- User based (IAM policies), in JSON
  - can block public access through these settings
- Resource based: bucket policies, Object Access Control List (ACL) or bucket
  ACL (less common)
- access is whether IAM _OR_ resource permissions allow.
- Can log and audit and store in another S3 bucket or access via CloudTrail
- Can enable MFA for deletion.
- Can have pre-signed URLs to resources with a limited time of access

IAM: Difference between bucket and bucket/*
- list actions are on bucket level, like `arn:aws:s3:::blah`
- get/put/delete are on objects level, like `arn:aws:s3:::blah/*`

S3 Websites: host static sites from
<bucket-name>.s3-website.<AWS-region>.amazonaws.com
- will get 403s if policy doesn't expose to public

CORS [Cross-Origin Resource Sharing]
- origin is a scheme (protocol), host (domain), and port (e.g.,
https://www.example.com)
- browser-based security to prevent access across schemes
- CORS Headers: "Access-Control-Allow-Origin" and
  "Access-Control-Allow-Methods"
- These are defined on the secondary resource, allowing the primary resource
  to access.

Consistency Model
- Strong consistency as of December 2020
  - After a successful PUT or DELETE, subsequent read or list request reflects
    changes.
    "read after write consistency" and "list consistency"

## IAM and Policies

Can create in-line policies attached to a role, but not recommended.

Can use UI to create policies, and there is an AWS Policy Generator tool as
well.

AWS Policy Simulator: Tool online for testing your policies

EC2 Instance Metadata: Allows EC2 instances to learn about themselves without
using an IAM role!
- http://169.254.169.254/latest/meta-data/ (internal to AWS from instance,
  trailing "/" important) [also /user-data/ and /dynamic/ at same base]
  - e.g., http://169.254.169.254/latest/meta-data/iam/security-credentials/
- You can get IAM Role from meta data, but not the IAM Policy
- "Metadata": info about the EC2 instance, vs.
- "Userdata": launch script of the EC2 instance
- Don't need an IAM role to access this information.

SDK: The CLI uses the Python SDK (boto3).
- If you don't select a region, SDK defaults to "us-east-1"
- Some things have to be done through the SDK, no available to console

## Advanced S3 and Athena

MFA-Delete: can only be enabled via CLI and by root account
- need to create an API token to do this, BUT not recommended to use those
  creds for anything else.
  - Best to deactivate and delete after use.
```
aws configure --profile root-access-<you-decide>

aws s3api put-bucket-versioning --bucket <bucket-name> \
  --versioning-configuration Status=Enabled,MFADelete=Enabled \
  --mfa "<arn-of-mfa-device> <mfa-code>" \
  --profile root-access-<you-decide>
```
^^ That "mfa-code" is the actual 6-digit code right now.

- To disable, same command but "MFADelete=Disabled"

Encryption: few ways including two different policies
(DenyIncorrectEncryptionHeader and DenyUnEncryptedObjectUploads)
- Can set default encryption in S3
- Bucket Policies are evaluated before "default encryption"

Access Logs: allows logging of all interaction with S3.
- WARN: Never set logging bucket to be one you are monitoring.

S3 Replication (CRR & SRR)
- have to have versioning enabled to use
- Cross Region Replication (CRR) use cases: compliance, lower latency access,
  replication across accounts
- Same Region Replication (SRR) use cases: log aggregation, replication
  between prod and test accounts.
- Buckets can be in different accounts
- copying is asynchronous
- Must have proper IAM permissions to S3
- only NEW objects are replicated, not retroactive
  - optional how to handle deletions
  - version ID is the same between replications
- No chaining of replication

Pre-signed URLs
- for downloads can use SDK or CLI, but uploads must use SDK
- default expiration is 1 hour, change with --expires-in [seconds]
- URL will inherit the permissions of the role used to create URL, so can
  include GET / PUT
```
aws s3 presign s3://<bucket>/<key> --region <region> --expires-in 300
```
If there are issues, may have to do
`aws configure set default.s3.signature_version s3v4`

Storage Classes:
- Standard: High durability (11 9s)
- Standard-Infrequent Access (IA): for anything less frequently accessed, but
  requires rapid access when needed. Lower cost vs Standard
  - Good for disaster recovery and backups
  - minimum storage is 30 days
  - minimum size (charge) is for 128KB
- One Zone-Infrequent Access: about 20% cheaper than IA, but 99.5% availability
  - Good for storing secondary backups or data that can be recreated (like
  thumbnails).
- Intelligent Tiering: small fee to have AWS move data between Standard and IA
  based upon access patterns
- Glacier: Ideal for data needing long-term retention (think 10 years),
  alternative to on-prem magnetic tape
  - $0.004/GB + retrieval cost
  - called "archive" not objects, and up to 40TB each, and "vaults" not buckets
  - Retrieval options: Expedited (1–5 min), Standard (3–5 hr), Bulk (5–12 hr)
  - minimum storage duration is 90 days
  - minimum size (charge) is for 40KB
- Glacier Deep Archive:
  - Retrieval options: Standard (12 hr), Bulk (48 hr)
  - minimum storage duration is 180 days
- (There's also a Reduced Redundancy Storage which is deprecated)

Lifecycle Rules: Allows transition and expiration actions
- e.g., move to IA after 60 days, Glacier after 6 months, delete after x days
- Can use to remove older "versions"

Storage Class Analytics: Daily report, takes 24–48 hrs to start, for
transitioning between Standard and IA (but not One-Zone or Glacier)
- Good first step for improving Lifecycle Rules

Baseline performance:
- 100-200ms latency
- at least 3500 PUT/COPY/POST/DELETE per second (per prefix)
- at last 5500 GET/HEAD per second (per prefix)
- "prefix" -> anything in the key up to the filename

KML Limitation: Using SSE-KMS can hit up against KMS limits
- Uses GenerateDataKey and Decrypt APIs when accessing, so counts against
  quota (can be 5500, 10000, or 30000 req/s depending upon region)
  - Have to use Service Quotas Console to go over those limits

Multi-Part upload, parallelizes upload to speed upload
- recommended for > 100MB
- required for > 5GB
S3 Transfer Acceleration: moves files to edge to speed up transfers
- e.g., in U.S. you upload to U.S. server, and transfer to an Australian
  server is does inside AWS for you.
Byte-Range Fetches: for speeding up GETs (and better resilience)
- pulls byte chunks of source file
- can also be used to only retrieve header

S3 Select & Glacier Select: use SQL queries for server side filtering to
retrieve less data.
- Can only filter by rows and columns, but pushes filtering server-side for
  speed up

Event Notifications:
- options: SNS topic (to email, SMS, or HTTP endpoints), SQS queue, Lambda function
- typically delivered within seconds, but count take longer than 1 min
- Need versioning enabled to ensure notifications on all writes

Requester Pays: Owner pays for storage, but requester pays for networking costs
- Requester must be logged into AWS.
- Good for sharing cost of large datasets

Glacier Vault Lock: to adopt a WORM (Write Once Read Many) model
- A file can only be written once, helpful for compliance and data retention.
S3 Object Lock: WORM
- have to designate time to block deletion
- Retention: 1) Retention Period (fixed period), 2) Legal Hold (no expiry date)
- Modes: 1) Governance (block overwrite/deletion except special permisions)
  2) Compliance (even root cannot overwrite/delete!)

### Athena

Serverless query service to perform analytics against S3 objects
- Uses standard SQL
- Supports CSV, JSON, ORC, Avro, and Parquet (on Presto)
~ $5/TB data scanned, so compressed and columnar data saves $
- Can connect to QuickSight for reporting
- Use cases: BI, analytics, analyzing VPC Flow Logs, ELB logs, CloudTrail
- search online for "Athena Query Access Logs" for SQL examples to set up Athena

## CloudFront

Content Delivery Network (CDN), to improve read performance cached at the
edge. At least 216 points of presence globally (edge locations).
- includes DDoS protection, integration with Shield, AWS Web Application
  Firewall

Origins:
- S3 bucket, includes enhances security with Origin Access Identity (OAI)
  - Can also be used as an ingress for uploading S3 files
- Custom Origin (HTTP), like ALB, instance, S3 as website, any HTTP service.

Acts as a cache for requests. Passes along entire request, including headers
and query strings.

With ALB or EC2 instances, the origin must be publicly available for
CloudFront to access them. There's a list of the CloudFront IPs that you can
search for to add to security groups.

Geo Restriction: can use whitelist or blacklist, to prevent banned countries
from accessing (like for copyright laws, etc.)

CloudFront vs S3 Cross Region Replication
- CloudFront: files are caches for a TTL, great for static content that must
  be available everywhere.
- S3 CRR: must be set up in each region you want it, changes are near
  real-time, read-only, great for dynamic content that needs to be available
  at low cost in a few regions.

Signed URL / Signed Cookies
- to restrict access to content, such as premium or paid access.
- Needs a policy with:
  - URL expiration, can be minutes or years
  - IP ranges to accept from
  - Trusted signers (which AWS accounts can create the signed URLs)
- Signed URL: one per file
- Signed Cookies: allow access to multiple files.
- Your application has to use the SDK to generate the Signed URL, then return
  to the client to use for access.

CloudFront Signed URL vs S3 Pre-Signed URL
- CloudFront allows access to path no matter the origin; account wide
  key-pair; can filter by IP, path, date, expiration; and leverages caching
- S3 uses the creator's IAM access for the URL, and has a limited lifetime

Price Classes:
- All: best performance
- 200: most regions, but excludes most expensive regions (North America,
  Europe, Asia, and Africa, NOT South America or Australia)
- 100: only the least expensive regions (North America & Europe)

Multiple Origin: can set different behaviors based upon path (e.g., /images/*
vs /api/*).
Origin Groups: To increase high availability, with primary and failover
origins.

Field Level Encryption: additional layer along with HTTPS
- Information encrypted at the edge close to the user, using asymmetric
  encryption
- Usage: designate set of fields in POST to encrypt (like Credit Card info)
  - Final web server then has access to key to decrypt.

## Global Accelerator

Unicast vs Anycast IP
- Unicast: one server holds the IP
- Anycast: multiple servers have same IP address and client routed to closest

Leverages AWS internal network to route to your application
- Creates two IP addresses for your app
- works with Elastic IP, EC2, ALB, NLB, public or private
- No issue with client cache because IP doesn't change regardless of location
- Includes health checks with <1min failover
- Easy to whitelist with only 2 IPs
- DDoS protection with AWS Shield

vs CloudFront
- proxying packets at edge
- good for non-HTTP use cases, like gaming (UDP), IoT (MQTT), or VoIP
- good for HTTP cases that require a static IP address

## Snow Family

Highly secure, portable devices to collect and process data at the edge,
migrating data in and out of AWS.
- Data migration: Snowcone, Snowball Edge, Snowmobile
- Edge computing: Snowcone, Snowball Edge

These are offline devices that AWS sends to you for migrating massive amounts
of data. AWS puts the data in S3 for you.
Rubric: if it would take more than a week to transfer data, use a Snowball device.

Snowball Edge: physical data transport for TBs or PBs of data.
- Storage Optimized: 80TB of HDD capacity
- Compute Optimized: 42TB of HDD capacity
- Can cluster up to 15 together

Snowcone: smaller device than Edge, more rugged. 8TBs of storage.
- Better if the Edge device is too large.
- Can send back to AWS or connect to AWS DataSync.

Snowmobile: is an actual truck. Exabytes of data (1 EB = 1000 PB = 1000000 TB)
- each snowmobile is 100 PB of capacity
- recommended for > 10 PB

Edge computing: processing data when it is away from the internet, like a
truck, ship, or in a mine. Assumes limited or no internet access.
- Edge devices can run EC2 instances or Lambdas directly (AWS IoT Greegrass)

AWS OpsHub: GUI you can install to manage these Snow devices

Snowball cannot import into Glacier directly, so would have to use a Lifecycle
Policy to transfer.

## Amazon FSz

Launch 3rd party high-performance file systems on AWS, like Lustre, Windows
File Server, or NetApp ONTAP. Fully managed.

Windows: supports SMB protocols and NTFS. Active Directory integration.
- This is what you would use for shared Windows FS (EFS is POSIX)

Lustre: "Linux" + "cluster", parallel distributed file system for large-scale
computing.
- Machine learning or High Performance Computing (HPC)
  - e.g., Video processing, financial modeling, electronic design automation
- Seamless integration with S3

File System deployment options:
- Scratch: temporary, data is not replicated. But high bursts (6x faster)
  - good for short-term processing to optimize costs
- Persistent: long-term storage, replicated in AZ, replace failed files in minutes
  - usage: long-term processing, sensitive data

## Storage Gateway

For hybrid cloud solutions, some in AWS some on-prem. Bridge storage to S3.
Allows for import into EBS, S3, or Glacier. This is something installed in
our corporate data center to smooth communication to AWS.

Three types:
- File Gateway: using NFS and SMB protocol. Can be integrated with Active
  Directory locally.
  - Can get native access for Windows File Server.
  - Includes local cache for frequently access data.
- Volume Gateway: block storage using iSCSI protocol
  - Cached volumes: low latency access to most recent data
  - Stored volumes: entire dataset on premise with scheduled backups to S3
- Tape Gateway: uses Virtual Tape Library (VTL) to back up to S3, iSCSI protocol.

You can also order a hardware appliance through the console.

## Transfer Family

Fully-managed service for file transfers into and out of S3 or EFS using FTP.
Can integrate with existing authentication systems (AD, LDAP, Okta, Cognito, ...)

## Simple Queuing Service (SQS)

Producers send messages to a Queue, Consumers poll for messages.

### Standard Queue

Fully managed. One of AWS's oldest systems. Unlimited throughput and unlimited
number of messages in a queue.
- Default retention: 4 days, maximum of 14 days
- Low latency, < 10ms on publish and receive
- Limit of 256KB per message
- Can have duplicate messages, "at least once" delivery
- Can have out of order messages, "best effort ordering"

Producer uses `SendMessage` API of SDK
- message is persisted until consumer deletes it
Consumer
- can poll for up to 10 messages at a time.
- use the `DeleteMessage` API to remove processed messages
- perfect use case for ASG to scale consumer instances to handle queue
  - CloudWatch Metric: Queue Length = `ApproximateNumberOfMessages`
  - So CloudWatch Alarm can trigger scaling on queue length

Security
- Encryption:
  - In-flight using HTTPS API
  - At-rest using KMS keys
  - Client-side encryption if client does the work.
- IAM policies to regulate API
- SQS Access Policies for cross-account access

Access Policy
- Cross Account Access: different AWS account polling
- Publish S3 Event Notifications to SQS Queue needs an explicit policy

Message Visibility Timeout: after message polled by consumer, it becomes
invisible to other consumers.
- default timeout of 30 seconds
- consumer can call `ChangeMessageVisibility` API to extend the lease if
  taking more than the limit
  - if the window is missed, can get duplicate message handling.
- There is a receive count to see how many times a message was received by
  some consumer.

Dead Letter Queues (DLQ): useful for debugging
- able to set threshold on how many times a message can be received without
  getting handled, `MaximumReceives`.
- Set high retention to be able to check these messages.
- configured against another queue to send to.

Delay Queue: up to 15 minute delay to avoid being handled right away
- Default is 0 seconds, can set at queue level
- Can explicitly send using `DelaySeconds` parameter

Long Polling: consumer waiting for messages when there are none available
- up to 20 seconds (preferred)
- decreases number of calls to API, while increasing efficiency and latency of
  application
- wait time between 1–20 seconds
- consumer can also set with `WaitTimeSeconds`

Request-Response Systems:
- system where there are separate request and response queues to separate
  producers and consumers from each other. Need correlation ID to map
  responses.
- There is a "SQS Temporary Queue Client" (Java-based) that AWS provides for
  this pattern. It uses virtual queues to be more cost-effective.

ASG: set up custom metric of Queue Length / Number of Instances
- need second alarm for reducing number of instances
- nothing provided out of the box from AWS for this

### FIFO

Limited throughput: 300 msg/s without batching, 3000 msg/s with
Exactly-once send capability, and guarantee that messages are processed in order.

Naming: has to end in ".fifo"

Allows for content-based deduplication within window

## Simple Notification System (SNS)

Pub/Sub system. Max 10,000,000 subscriptions/topic. 100,000 topic limit

"Event producer" only sends to one SNS topic
"Event receivers" (subscribers) can have as many as we want to listen for notifications.

Each subscriber gets all messages sent to a topic (although filtering is
available)

Possible subscribers: SQS, HTTP (with retries), Lambda, email, SMS, Mobile

SNS integrates with a LOT of AWS services.

Also "Direct Publish" for mobile SDKs, to publish to a platform endpoint

Fan Out: SNS + SQS
- Push once in SNS, all SQS subscribers receive.
- fully decoupled, no data loss, and SQS provided data persistence.
- And can add new SQS subscribers over time.
- Example: S3 events to multiple queues.
  - Only allowed to have one S3 event rule per event type and prefix

SNS FIFO Topic is available (same throughput limitations as SQS)
- Only SQS can subscribe (unlike Standard).

Message Filtering: JSON policy on topic subscriptions

## Kinesis

To collect, process, and analyze streaming data in real time
- Kinesis Data Streams: capture, process, and store data streams
- Kinesis Data Firehose: load data streams into AWS data stores
- Kinesis Data Analytics: analyze data streams with SQL or Apache Flink
- Kinesis Video Streams: capture, process, or store video streams

Data Streams
- Divided into shards, 1 MB/sec or 1000 msg/sec per shard
- Producers push Records into stream with Partition Key and Data Blob up to 1MB
- Consumer also receives Record with Sequence number
  - Can have fan-out with multiple consumers
  - Shared 2 MB/sec per shared for all consumers (pull)
  - or, Enhanced, 2 MB/sec per share per consumer (push) (more $)
- Retention of 1 day (default) up to 365 days
- Allows for replaying of data.
- Immutability: once data entered into stream, cannot be deleted
- Producers: SDK, Kinesis Producer Library (KPL), Kinesis Agent
- Consumers: SDK, Kinesis Client Library (KCL), Lambda, Firehose, Analytics
- Use the partition key to ensure ordering in Kinesis
  - With SQS would use a Group ID for similar partitioning

Data Firehose
- Reads records up to 1MB at a time
- Can have Lambda function for any transformations
- Then does batch writes into target data store (so, near real-time service)
  - Near Real Time: 60 sec latency for non-full batches
  - Or, minimum 32 MB of data at time
- Destinations: S3, Redshift (via COPY through S3), ElasticSearch
  - Also 3rd parties: Datadog, Splunk, New Relic, mongoDB
  - or custom via HTTP endpoint
- Able to send all or just failed data to S3 backup bucket
- Fully managed, so pay for data going through.

Data Analytics
- Sources & Sinks: Kinesis Data Streams or Kinesis Data Firehose
- Use SQL statements to process and redirect real-time data
- Fully managed, pay for consumption rate
- Use cases: Time-series analytics, real-time dashboard or metrics

## Amazon MQ

Managed Apache ActiveMQ

Allows you to use existing protocols (SNS/SQS are proprietary)
- MQTT, AMQP, STOMP, Openwire, WSS

Use case: migrating existing applications into the cloud without rewriting
your queueing.

Doesn't "scale" as much as SQS/SNS, runs on dedicated machine, but can run
with HA failover.
- failover using EFS within region but across AZ.

## Elastic Container Service (ECS)

For launching Docker containers on AWS. You must provision and maintain the
infrastructure (EC2 instances), but AWS takes care of starting/stopping
containers. Integrates with ALB.

Launch Types:
- Amazon EC2 Launch Type: ECS cluster can cross AZ within region, in a single
  ASG. ECS Agent runs on each instance.
- Fargate: Launch Docker containers but you do NOT provision the
  infrastructure. (i.e., simpler) ... "serverless" offering
  - AWS calculates based upon CPU/RAM that you need.
  - Launches "Task" inside cluster, using ENI for network interface. Each
    takes an IP, so have to have enough dedicated in the cluster.

IAM Roles for ECS Tasks
- EC2 Instance Profile: used by the ECS agent, to make API calls to ECS
  service, send container logs to CloudWatch, pull Docker image from ECR, and
  reference Secrets Manager or SSM Parameter Store.
- ESC Task Role: specific to each task for what your app/service needs.
  - defined in the task definition, unique by task type.

EFS can be used to share data between instances/tasks.

ECS Services & Tasks
- Common with ALB to have each task get assigned a random port that then ties
  into the load balancer. "dynamic port mapping"
  - Security: must allow any port from the ALB security group.
- Fargate is different, since each task gets own IP from ENI, so same port is
  exposed by task.

Event Bridge: build a rule to run an ECS task, which handles launching task for you.

ECS Scaling Examples
- CloudWatch Metric based upon ECS Service CPU Usage, trigger CloudWatch Alarm
- Can also increase instances with Capacity Providers (i.e., not Fargate)
- Could also configure to something like SQS queue length, if workers in ECS

ECS Rolling Updates
- can control how many tasks are started and stopped and in which order
- Use minimum and maximum healthy percent to determine rate

## Elastic Container Registry (ECR)

Store, manage, and deploy containers, paying for what you use
Fully integrated with ECS & IAM, backed by S3
- Can do vuln scanning and other actions on these images
- Integration with CodeBuild

## Elastic Kubernetes Service (EKS)

Kubernetes is open-sources system for automatic deployment, scaling, and
management of containerized (usually Docker) applications.
- Alternative to ECS, similar goal but different API
- Supports both EC2 and Fargate modes, like ECS
- Kubernetes is cloud-agnostic
- "Pods" include nodes, exist inside ASG

## Serverless

"Serverless" now means that you don't manage/provision the server. Idea was
pioneered by AWS Lambdas, though, meaning Function as a Service (FaaS).

Includes: AWS Lambda, DynamoDB, Cognito, API Gateway, S3, SNS, SQS, Kinesis
Data Firehose, Aurora Serverless, Step Functions, Fargate

## Lambda

Virtual functions, limited by time (up to 15 min), that run on demand, with
automated scaling

Free tier: 1,000,000 Lambda requests and 400,000GB of compute time per month

Can increase RAM up to 10GB (which also improved CPU and network)

Languages: Node.js, Python, Java, .NET Core, Golang, C# / Powershell, Ruby
- Customer Runtime API (community supported) to run other languages
- Lambda Container Image: implementing Lambda Runtime API
  - ECS / Fargate preferred for arbitrary Docker images

Limitations:
- Execution: 128MB–10GB
  - 4KB of environment variables
  - 512MB disk capacity in "function container" under /tmp
  - Concurrent executions: 1000 (but can request more)
- Deployment: 50MB max (compressed ZIP)
  - 250MB uncompressed
  - Can use /tmp to load other files during startup

Lambda@Edge: deployed alongside CDN using CloudFront
- Use lambdas to change request or response, four types:
  - viewer request: between user and CloudFront
  - origin request: between CloudFront and origin
  - origin response
  - viewer response
  - ... so could avoid hitting origin by using viewer request and response
- Use cases: security and privacy, dynamic web app at edge, SEO, intelligently
  route across origins and data centers, bot mitigation, real-time image
  transformation, A/B testing, authentication and authorization, user
  prioritization, tracking and analytics

## DynamoDB

NoSQL DB, Fully managed, highly available with replication across multiple AZs
- millions of requests/sec, trillions of rows, 100s of TB of storage
- low latency on retrieval
- enables event-driven programming with DynamoDB Streams

DB is made of tables, primary key must be decided at creation time, infinite
number of rows.
- each item has attributes that can be added over time and can be null
- max item size 400KB
Data types:
- Scalar types: string, number, binary, boolean, null
- Document types: list, map
- Set types: String set, number set, binary set

Primary key can be composed of 1–2 columns. Partition Key (required) and Sort
Key (optional)

Read/Write Capacity Modes
- Provisioned (default): specify read/writes per second, so plan ahead
  - pay for provisioned Read Capacity Units (RCU) and Write Capacity Units (WCU)
  - Can add auto-scaling based upon RCU and WCU target utilization
- On-Demand Mode
  - scales based upon reads/writes, so pay for what you use
  - about 2–3x more expensive, but great for unpredicatable workloads

DynamoDB Accelerator (DAX)
- Seemless in-memory cache for DynamoDB
- Helps solve read congestion by caching
- microsecond latency for cached data
- Doesn't require any changes to application logic
- 5 minutes TTL (default)
- vs. ElastiCache, EC would be better for storing calculated or aggregated
  data

DynamoDB Streams
- ordered stream of item-level modifications (create/update/delete)
- can send to Kinesis Data Streams, Lambda, or Kinesis Client Library apps
- Data retention up to 24 hours
- Use cases: react to changes in real-time (like welcome e-mails), analytics,
  insert into derived tables, insert into ElasticSearch, cross-region
  replication

DynamoDB Global Tables
- Two-way replication across regions, for low latency across them
- "Active-Active" replication, can read and write to table from any region
- Have to enable DynamoDB Streams as a prerequisite

Time To Live (TTL)
- automatically delete items after an expiry timestamp (built in function)
- You explicitly add an attribute to your items that it interacts with

Indexes
- Global Secondary Indexes (GSI) and Local Secondary Indexes (LSI)
- Allow for queries on attributes that are not the primary key

Transactions
- allow a guarantee that you write to two tables or neither.

## API Gateway

Publicly available REST endpoint for triggering serverless, proxying request
to Lambda.
- supports WebSocket Protocol
- can build in API keys and request throttling
- Swagger / Open API import support
- Can transform and validate requests at the Gateway
- Can cache API responses
- Maximum (and default) timeout is 29 seconds

Can expose any AWS service through the API Gateway.

One use case is to use API Gateway in front of HTTP endpoints to handle rate
limiting.

Endpoint Types:
- Edge-Optimized (default): for global clients, routing through CloudFront Edge
  - API Gateway still lives in only one region
- Regional: for clients in the same region
- Private: only accessible from VPC using a resource policy

Security:
- IAM Permissions: good for access within your own infrastructure
  - Leverages "Sig v4" capability with IAM creds in headers
  - no additional costs, but limited to folks with IAM permissions
- Lambda Authorizer: uses Lambda to validate token in header
  - Can cache result of authentication (for up to 1 hour)
  - use with OAuth, SAML, other 3rd party auth
  - Lambda must return IAM policy for user
- Cognito User Pools: API Gateway automatically verifies with Cognito
  - Cognito only helps with authentication, not authorization
  - up to your backend to handle authorization
  - pools can be backed by Facebook, Google, etc. logins

## Cognito

When we want to give users an identity to interact with our application

Cognito User Pools (CUP):
- Sign-in functionality for app users
- Allows for simple login, like username/password, incl. 2FA
- Sends back JSON Web Tokens (JWT)
Cognito Identity Pools (Federated Identity):
- Provide AWS credentials to users so they can access resources directly
- Get temporary credentials back from pool with temporary, predefined IAM policy
- Example use: temporary access to write to S3
Cognito Sync (deprecated and replaced by AppSync):
- synchronize data from device to Cognito

Federation options: SAML 2.0, Custom Identity Broker, Web Identity Federation
with or without Amazon Cognito, Single Sign On, Non-SAML with AWS Microsoft AD
- With federation, no need to create IAM users, that's managed outside of AWS

SAML 2.0 Federation: to integrate with Active Directory / ADFS with AWS
- provides access to AWS Console or CLI
- no need to create an IAM user for each employee
- this is considered "old way" of doing things, Amazon SSO is newer/simpler

Custom Identity Broker Application
- use only if identity provider is no compatible with SAML 2.0
- Use AssumeRole or GetFederationToken APIs
- your custom broker is the one talking to STS in this case

Web Identity Federation, AssumeRoleWithWebIdentity
- Not recommended by AWS (use Cognito instead)


## Serverless Application Model (SAM) (squirrel logo)

Framework for developing and deploying serverless applications
- Configuration is all in YAML
- Also allows for running locally for testing/debugging
- integrates with CodeDeploy

## Simple Email Service (SES)

## Redshift

Based on PostgreSQL, but not used for OLTP. Designed for OLAP (OnLine
Analytical Processing).
- Can store PB of data.
- Massively Parallel Query Execution (MPP)
- Integrated with BI tools, like Quicksight or Tableau
- 1–128 nodes, each up to 128TB of space
  - Leader node: for query planning and results aggregation
  - Compute node: for performing the queries and send results to leader
- AWS claims 10x performance vs other data warehouses

Redshift Spectrum: run queries directly against S3 without loading.
- query is distributed among 1000s of Spectrum nodes (separate from compute nodes)

Redshift Enhanced VPC Routing: COPY / UNLOAD commands go through VPC instead
of public internet.

No Multi-AZ mode, need to use snapshots (stored in S3) for recovery.
- snapshots are incremental (i.e., diffs)
- Can restore snapshots into a new cluster
  - Can configure to automatically copy snapshots to another Region
- Can automate, e.g., every 8 hours, every 5GB, or on schedule
- Can set retention (TTL), otherwise remain until manually deleted.

Load data:
- Kinesis Data Firehose (through S3 copy)
- S3 bucket using COPY command (with or without VPC Routing)
- Push from EC2 using JDBC driver (be sure to write in batches)

vs Athena: Redshift has faster queries, joins, and aggregations by using indexes.

## Glue

Managed extract, transform, and load (ETL) service
- use case: preparing and transforming for analytics

Glue Data Catalog: metadata about all your AWS datasets
- Glue Data Crawlers: crawl your RDS, S3, DynamoDB, or JDBC compliant
- Includes table names, fields, and data types
- Used by Glue Jobs (ETL), Athena, Redshift Spectrum, and EMR

## Neptune

Fully managed graph DB.
- Can use clustering to improve performance.

## OpenSearch (aka, ElasticSearch)

Common to use as a complement to other DBs for searching and indexing.
vs. DynamoDB, can search any field, even partial matches.
- built-in integrations with Kinesis Data Firehose, AWS IoT, and CloudWatch Logs
- multi-AZ, clustering, reported to scale to PB of data

ELK stack: Comes with Kibana (visualization) and Logstash (log ingestion)

Supports Cognito for security.

## CloudWatch

Metrics for every service in AWS.
Metrics belong to namespaces, have timestamps.
Dimension is an attribute of a metric, up to ten dimensions per metric.

Detail monitoring. You can pay extra to get metrics more often, which can be
helpful if you need to scale faster in an ASG. (default every 5 minutes)
- Free tier allows 10 detailed monitoring metrics

PutMetricData: API call to push custom metrics
- memory (RAM) usage, disk space, number of logged in users
- EC2 memory usages it not a default metric, has to be pushed from inside
  instance as a custom metric.
- Up to you to provide useful dimensions, like instance ID or environment name
- Metric resolution (with `StorageResolution` API parameter) can be
  - standard: 1 minute
  - high resolution: 1/5/10/30 seconds
- You can push metrics with timestamps as old as two weeks and up to two hours
  into future, so ensure that instance has time set correctly.

Dashboards: There are plenty of built-in, but can also create custom ones.

Logs
- groups: arbitrary name, usually of your application
- stream: an instance within the application / log files/ containers
- can define expiration policy (storage costs $)
- can send to S3, Kinesis Data Streams, Kinesis Data Firehosem, Lambda, and
  ElasticSearch
- SDK, CloudWatch Logs Agent for sending custom logs

Metric Filters and Insights
- can filter on different things, like specific IP or "ERROR"
- can be used to trigger alarms
- Log Insights can be used to query logs, or add them to dashboard
- Can aggregate across accounts or regions

S3 Export: isn't real-time, can take up to 12 hours, via `CreateExportTask`
- use Log Subscriptions instead for real-time

CloudWatch Agent: for pushing logs from EC2 instance
- by default, no logs are coming from EC2
- can set up agent to capture logs, provided IAM permissions
- "Logs Agent" is an older version only sending logs
- "Unified Agent" is newer and also includes system-level metrics

CloudWatch Alarms
- States: OK, INSUFFICIENT_DATA, ALARM
- Targets:
  - Stop, terminate, reboot, or recover an EC2 instance
    - Recovery: same IPs, metadata, and placement group
  - Trigger Auto Scaling action
  - SNS
- Can set alarm state from CLI to test. `aws cloudwatch set-alarm-state ...`

CloudWatch Events -> displaced by CloudWatch EventBridge
- default event bus is generated by AWS services
- same thing, but name shifting to EB over time

## EventBridge

Builds on CloudWatch Events (same API and endpoints), but extends with more buses

Default event bus: generated by AWS, same as with CW Events
Partner event bus: Can receive events from other SaaS providers, e.g., Zendesk, DataDog, Segment,
Auth0, ...
- They can send events into your system in real time
Custom event bus: for your own applications, so that some apps can react to
other apps

Schema Registry: EventBridge can analyze events in bus and infer the schema
- can be versioned
- allows you to generate code for your app knowing in advance the event bus data

## CloudTrail

Provides governance, compliance, and audit for your AWS account. Enabled by
default.
- History of events/API calls made within your AWS account.
- Can separate read and write management events

Can put logs into CloudWatch Logs or S3, if needed for more than 90 days.

Data Events: high volume operations are not logged by default
- includes things like reading from S3, Lambda function activity, etc.

Insights: has to be enabled, but will detect unusual activity in your account.
- analyzes write events, and will generate EventBridge event

## AWS Config

Help with auditing and compliance of AWS resources, recording configuration
changes over time.
- e.g., checking for unrestricted SSH access, public access on S3 buckets
- AWS provides over 75 config rules to help monitor common scenarios
- Does not prevent the actions, just confirm compliance with rules
- no free tier

Can configure remediation of non-compliant resources with SSM Automation
Documents
- e.g., Could automatically revoke API keys after 90 days
- Can wire up to Lambda function

Notifications to EventBridge or SNS.

## Security Token Service (STS)

Grant limited and temporary access to AWS resources. Valid for 15 min up to 1 hour

- AssumeRole: within own account or Cross Account Access to perform action for
  target account.
- AssumeRoleWithSAML: for users logged in via SAML
- AssumeRoleWithWebIdentity: return creds for users logged in with an identify
  provider (Facebook Login, Google Logic, OIDC compatible)
  - AWS recommends against this, prefer Cognito instead
- GetSessionToken: for MFA

## AWS Directory Services

Microsoft Active Directory
- AD objects are organized in "trees", a group of trees is a "forest"
- it is a DB of object: User Accounts, Computers, Printers, File Shares, ...

AWS Managed Microsoft AD: create your own AD in AWS
- establish "trust" connections with on-prem AD
- users exist in both ADs

AD Connector: Direct Gateway (proxy) to redirect to on-prem AD
- Users are managed in the on-prem AD

Simple AD: AD-compatible managed directory on AWS
- Cannot be joined with on-prem AD

## AWS Organization

Global service to manage multiple AWS accounts.

Main account in "master" account, you cannot change it. Other accounts are
"member" accounts.
- member accounts can only be part of one organization

This is about consolidating your billing across accounts. Single payment
method, and pricing benefits from aggregated usage (volume discount).

May want to use this for separating departments as cost centers, based upon
regulatory restrictions, or for better resource isolation (e.g., VPCs)
- This approach makes it harder for distinct VPCs to accidentally talk to each
  other.
- Can still centralize CloudTrail and CloudWatch
- Allows for cross-account roles for Admin purposes

Organization Units (OU): up to you how to organize: by business unit, but
environment, by project, etc.

Service Control Policies (SCP): allow or deny list of IAM actions, applied at
OU or Account level, but don't apply to management account.
- applies to all users and roles (including root) of account
  - But cannot restrict service-linked roles for cross-org integration
- Allows have to be explicit, nothing enabled by default
- Use cases: restrict access to certain services or enforce PCI compliance by
  disabling services
- Hierarchy, so if a parent is denied something, it cannot be explicitly
  granted to a sub-account in the hierarchy.
- Migrating accounts: have to leave first org, then get invited to new org,
  since only allowed to be member of one org at a time.
  - to migrate root, have to migrate all users first, delete OU, then migrate

## Resource Access Manager (RAM)

Allows you to share AWS resources you own with other AWS accounts, to avoid
resource duplication.
- Can share VPC subnets, but cannot share security groups or default VPC
- participants cannot view, modify, delete resources that belong to other
  participants
- Can share: AWS Transit Gateway, Route53 Resolver Rules, License Manager Config
- Can access other services in the subnet using the private IP, and
  referencing the security groups

## AWS Single Sign-On (SSO)

Centrally manage access to multiple accounts and 3rd-party business applications
- e.g., Dropbox, Office365, Slack
- integrates with AWS Organizations, SAML 2.0 markup, and Active Directory

vs AssumeRoleWithSAML: assume role would be required for each login/service

## Key Management Service (KMS)

Mostly when documentation in AWS talks about "encryption", it is referring to
KMS. Fully managed by AWS.
- Never store secrets in plain text. Encrypted secrets can be stored in
  code/environment variables.
- Keys are bound to a single region

Customer Master Keys (CMK) types:
- Symmetric (AES-256 keys), you never get access to the Key unencrypted
- Asymmetric (RSA & ECC key pairs), public keys for encryption, private key
  for decryption
  - cannot get access to private key unencrypted
  - use case: encryption outside of AWS by users who cannot call KMS API

CMK cost:
- AWS Managed Service Default CMK: free
- User Keys created in KMS: $1/month
- User Keys imported (256-bit symmetric), $1/month
- Then you pay for each API call to KMS (~ $0.03/10000 calls)

KMS can only encrypt up to 4KB of data per call
- Have to use envelope encryption if larger

To give access to KMS:
- Key Policy allows the user
- IAM Policy allows the API calls

Key Policies
- cannot control access without them (unlike other Policies)
- Default KMS Key Policy:
  - Complete access to the key to the root user = entire AWS account
  - named with "aws/<service-name>"
- Custom policy:
  - define users, roles that can access
  - define who can administre
  - useful for cross-account access

Copy snapshots across regions:
1. create snapshot (encrypted with your CMK)
2. attach a KMS Key Policy to authorize cross-account access
3. Share the encrypted snapshot
4. (target) create copy of snapshot, encrypt with own KMS key
5. create volume from snapshot in target

Key Rotation
- can only configure for customer-managed CMK (not AWS managed)
- When enabled, happens every 1 year
- previous key kept in order to decrypt older data
- new key has the same CMK ID, only the backing key is changed
Manual Rotation
- new key will have a new CMK ID
- better to use aliases in this case to hide change of key from apps
- ideal rotation for CMK not eligible for auto-rotation, like asymmetric CMK

## SSM Parameter Store (accessed via AWS Systems Manager)

Securely store secrets (e.g., for configuration). Serverless.
- version tracking of configuration/secrets
- management using path & IAM
- integrated with CloudFormation

Can store with hierarchy, e.g., `/department/app/dev/db-url`

Teirs:
- Standard, free, up to 10,000 parameters up to 4KB each
  - no parameter policies available
  - no charge for standard throughput, but higher costs $0.05/10000 tx
    - high throughput = > 1000 tx/sec
- Advanced, charge, up to 100,000 parameters up to 8KB each
  - parameter policies available
    - includes TTL to force update/delete
    - can include notifications of pending deadlines.
  - charge regardless of throughput

## Secrets Manager

Newer than SSM. Has capability to force rotation of secrets every X days.
- can automate generation of secrets on rotation using Lambda
  - Lambda has to have permission to create/rotate they keys
- integrates with RDS, and that's its primary focus
  - does support key-value pairs as well, like for API keys
- no free tier, costs $0.40/secret/month and $0.05/10000 API calls

## CloudHSM

AWS provisions dedicated encryption hardware, and you manage your own keys
entirely.
- HSM device is tamper resistant, FIPS 140-2 Level 3 compliance (KMS is Level 2)
- Have to use CloudHSM Client Software to manage
- Redshift supports CloudHSM for database encryption
- Good option to use with SSE-C encryption
- IAM is only for CRUD of the HSM Cluster, but not managing keys/users
- Support for HM across regions
- Supports cryptographic acceleration

## AWS Shield

DDoS protection.

Standard:
- free for all customers
- protects against attacks like SYN/UDP Floods, reflection attacks, other
  layer 3/4 attacks
Advanced:
- $3000/month/organization
- protects against more sophisticated attacks
- Also 24/7 access to response team (DRP)
- protects against higher costs associated with DDoS usage spikes

## Web Application Firewall (WAF)

Protects web applications from common layer 7 exploits
- (layer 7 = HTTP, layer 4 = TCP)
- Can be deployed on ALB, API Gateway, or CloudFront
- define a Web ACL (Web Access Control List)
  - rules can include IP addresses, headers, body, URI strings
  - can protect against SQLi and XSS
  - can add size constraints (like on uploads)
  - can geo-match (block countries)
  - rate-based rules for DDoS protection
- cost about $5/month

Firewall Manager: tool for managing WAFs
- can also manage Shield Advance from here, as well as EC2 and ENI resources
  in VPC

## GuardDuty

Intelligent Threat discovery to protect AWS account, using machine learning to
detect anomalies
- input includes CloudTrail, VPC Flow, and DNS logs
- set up CloudWatch Event rule to SNS or Lambda
- has dedicated "finding" to protect against CryptoCurrency attacks

## Inspector

Automated security assessments for EC2 instances
- analyze running OS against known vulns
- analyze against unintended network accessibility
- AWS Inspector Agent has to be installed on EC2 instance
- possible to trigger SNS

## Macie

Fully managed data security and privacy service, using machine learning and
pattern matching to protect sensitive data (like PII).
- e.g., analyze S3 buckets for potential PII then notify

## Shared Responsibility Model

AWS's responsibility: security _of_ the cloud
- protecting infrastructure (hardware, software, facilities, networking)
- managed services
Customer responsibility: security _in_ the cloud
- keeping EC2 instances up to date, firewall, network config, IAM
- encrypting app data
Shared responsibility:
- patch management, configuration management, awareness & training

## Virutal Private Cloud (VPC)
