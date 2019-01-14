#!/usr/bin/env bash

# FIRST LOGIN TO CLUSTER
oc login -u system:admin

oc create -f ./library/official/mysql/imagestreams/mysql-rhel7.json -n openshift 
oc create -f ./library/official/nodejs/imagestreams/nodejs-rhel7.json -n openshift 
oc create -f ./library/official/ruby/imagestreams/ruby-rhel7.json -n openshift 
oc create -f ./library/official/postgresql/imagestreams/postgresql-rhel7.json -n openshift 
oc create -f ./library/official/eap-cd/imagestreams/eap-cd-openshift-rhel7.json -n openshift 
oc create -f ./library/official/datagrid/imagestreams/jboss-datagrid65-client-openshift-rhel7.json -n openshift 
oc create -f ./library/official/datagrid/imagestreams/jboss-datagrid71-openshift-rhel7.json -n openshift 
oc create -f ./library/official/datagrid/imagestreams/jboss-datagrid65-openshift-rhel7.json -n openshift 
oc create -f ./library/official/datagrid/imagestreams/jboss-datagrid72-openshift-rhel7.json -n openshift 
oc create -f ./library/official/datagrid/imagestreams/jboss-datagrid71-client-openshift-rhel7.json -n openshift 
oc create -f ./library/official/mongodb/imagestreams/mongodb-rhel7.json -n openshift 
oc create -f ./library/official/fis/imagestreams/fuse7-java-openshift-rhel7.json -n openshift 
oc create -f ./library/official/fis/imagestreams/apicurito-ui-rhel7.json -n openshift 
oc create -f ./library/official/fis/imagestreams/fuse7-console-rhel7.json -n openshift 
oc create -f ./library/official/fis/imagestreams/fis-karaf-openshift-rhel7.json -n openshift 
oc create -f ./library/official/fis/imagestreams/fis-java-openshift-rhel7.json -n openshift 
oc create -f ./library/official/fis/imagestreams/fuse-apicurito-generator-rhel7.json -n openshift 
oc create -f ./library/official/fis/imagestreams/jboss-fuse70-karaf-openshift-rhel7.json -n openshift 
oc create -f ./library/official/fis/imagestreams/fuse7-eap-openshift-rhel7.json -n openshift 
oc create -f ./library/official/fis/imagestreams/fuse7-karaf-openshift-rhel7.json -n openshift 
oc create -f ./library/official/fis/imagestreams/jboss-fuse70-eap-openshift-rhel7.json -n openshift 
oc create -f ./library/official/fis/imagestreams/jboss-fuse70-java-openshift-rhel7.json -n openshift 
oc create -f ./library/official/fis/imagestreams/jboss-fuse70-console-rhel7.json -n openshift 
oc create -f ./library/official/processserver/imagestreams/jboss-processserver63-openshift-rhel7.json -n openshift 
oc create -f ./library/official/processserver/imagestreams/jboss-processserver64-openshift-rhel7.json -n openshift 
oc create -f ./library/official/python/imagestreams/python-rhel7.json -n openshift 
oc create -f ./library/official/mariadb/imagestreams/mariadb-rhel7.json -n openshift 
oc create -f ./library/official/datavirt/imagestreams/jboss-datavirt64-driver-openshift-rhel7.json -n openshift 
oc create -f ./library/official/datavirt/imagestreams/jboss-datavirt64-openshift-rhel7.json -n openshift 
oc create -f ./library/official/httpd/imagestreams/httpd-rhel7.json -n openshift 
oc create -f ./library/official/sso/imagestreams/redhat-sso72-openshift-rhel7.json -n openshift 
oc create -f ./library/official/sso/imagestreams/redhat-sso71-openshift-rhel7.json -n openshift 
oc create -f ./library/official/sso/imagestreams/redhat-sso70-openshift-rhel7.json -n openshift 
oc create -f ./library/official/php/imagestreams/php-rhel7.json -n openshift 
oc create -f ./library/official/dotnet/imagestreams/dotnet-rhel7.json -n openshift 
oc create -f ./library/official/dotnet/imagestreams/dotnet-runtime-rhel7.json -n openshift 
oc create -f ./library/official/jenkins/imagestreams/jenkins-rhel7.json -n openshift 
oc create -f ./library/official/rhpam/imagestreams/rhpam70-kieserver-openshift-rhel7.json -n openshift 
oc create -f ./library/official/rhpam/imagestreams/rhpam70-businesscentral-openshift-rhel7.json -n openshift 
oc create -f ./library/official/perl/imagestreams/perl-rhel7.json -n openshift 
oc create -f ./library/official/redis/imagestreams/redis-rhel7.json -n openshift 
oc create -f ./library/official/eap/imagestreams/jboss-eap70-openshift-rhel7.json -n openshift 
oc create -f ./library/official/eap/imagestreams/jboss-eap71-openshift-rhel7.json -n openshift 
oc create -f ./library/official/eap/imagestreams/jboss-eap64-openshift-rhel7.json -n openshift 
oc create -f ./library/official/nginx/imagestreams/nginx-rhel7.json -n openshift 
oc create -f ./library/official/amq/imagestreams/jboss-amq-62-rhel7.json -n openshift 
oc create -f ./library/official/amq/imagestreams/jboss-amq-63-rhel7.json -n openshift 
oc create -f ./library/official/decisionserver/imagestreams/jboss-decisionserver64-openshift-rhel7.json -n openshift 
oc create -f ./library/official/decisionserver/imagestreams/jboss-decisionserver63-openshift-rhel7.json -n openshift 
oc create -f ./library/official/decisionserver/imagestreams/jboss-decisionserver62-openshift-rhel7.json -n openshift 
oc create -f ./library/official/rhdm/imagestreams/rhdm70-kieserver-openshift-rhel7.json -n openshift 
oc create -f ./library/official/rhdm/imagestreams/rhdm70-decisioncentral-openshift-rhel7.json -n openshift 
oc create -f ./library/official/webserver/imagestreams/jboss-webserver31-tomcat8-openshift-rhel7.json -n openshift 
oc create -f ./library/official/webserver/imagestreams/jboss-webserver31-tomcat7-openshift-rhel7.json -n openshift 
oc create -f ./library/official/webserver/imagestreams/jboss-webserver30-tomcat7-openshift-rhel7.json -n openshift 
oc create -f ./library/official/webserver/imagestreams/jboss-webserver30-tomcat8-openshift-rhel7.json -n openshift 
oc create -f ./library/official/java/imagestreams/java-rhel7.json -n openshift 
oc create -f ./library/official/java/imagestreams/redhat-openjdk18-openshift-rhel7.json -n openshift 
oc create -f ./library/official/3scale/imagestreams/apicast-gateway.json

