# AMQ Streams on OpenShift demo

## Cluster Operator

The cluster operator is the most important component in AMQ Streams on OpenShift.
It follows the usual Operator pattern of watching for changes on some desired resource and making changes in other resources to make them match the desired state.
It can be deployed like this:

    oc apply -f 01-install-cluster-operator/

In the case of the Cluster Operator, the desired resource represents a Kafka cluster.
This is stored as a Custom Resource within OpenShift.

Anyone who has tried to run Kafka for themselves will know that Kafka has a dependency on a Zookeeper cluster.
Kafka uses this for controller election and as a distributed map for holding metadata about topics, partitions, users and so on.
So the Custom Resource also allows us to configure the Zookeeper cluster required by the Kafka cluster.

Let's start off with the simplest possible Kafka cluster:

    cat 02-simplest-cluster.yaml
    oc apply -f 02-simplest-cluster.yaml

It's worth mentioning here that although I'm creating this `Kafka` resource in the same namespace that the Cluster operator is running in it doesn't have to be that way. The cluster operator can be configured with watch different namespaces than the one it's deployed in. Using a single namespace just makes the demo simpler.

When we create this in OpenShift the Cluster Operator will deploy:

* A `StatefulSet` for the Kafka brokers
* A headless `Service` for bootstrapping Kafka clients
* a `Service` for each broker
* A `StatefulSet` for the Zookeeper nodes
* A headless `Service` for XXXXXX
* A `Service` for each node
* Plus various other resources.

Having deployed this earlier I can see these already up and running

    oc get pods

Within and between these clusters communication will be encrypted via TLS. 
The version of Zookeeper that Kafka uses does not support TLS, so the communication there goes through an `stunnel` sidecar container which provides a secure tunnel.
Kafka itself supports TLS natively, but because each broker needs to communicate with Zookeeper we still need a TLS sidecar in each broker pod.

A key part of the operator concept is that an operator embeds operational knowledge of the thing it operates upon. For us, this means that the Cluster Operator needs to know when and how to do rolling restarts of the Kafka cluster, for example.

To save time I'm going to work through most of the demo with a Kafka cluster with a single broker.
This makes all the rolling updates quicker. We'll scale it up at the end.

## Configuring Kafka and Zookeeper

Kafka allows many parts of a broker to be customised.
We want to allow users the ability to customise their Kafka cluster within OpenShift in the same way. At the same time and in order for the operator to make running the cluster easy for users, the operator needs ownership of some of the Kafka configurables. For example, to make TLS work the operators needs to use some of the SSL-related configurables. So there's a list of options which the operator takes charge of and which users are forbidden from setting themselves.

All the rest of the configs can be specified by the user. For example here I'm going to change XXXXX:

    oc apply -f 03-with-config.yaml

## Configuring Authentication and Authorization

I've already mentioned that TLS is used for encryption within and between the Zookeeper and Kafka clusters. TLS can also be used for clients, both to provide encrypted communication and also for authentication. It's worth pointing out that this is mutual TLS authentication. So the identity of the client can be established on the broker using its TLS certificate, as well as the more common case where the client authenticate the server.

This happens in two parts.

Firstly I need to declare in the custom resource that I want to have a TLS listener – effectively that I want a socket listening that's set up for TLS. This will provide for enrypted communication between clients and brokers, but it won't use TLS authentication as this point. I do this by

    oc apply -f 04-with-tls-listener.yaml

Secondly I need to tell Kafka that I want to authenticate clients using thei TLS certificate they present over this new listener.

    oc apply -f 05-with-tls-authentication.yaml

## Resource limits

Kafka uses the OS page cache rather than having a data caching strategy of its own. This means that to use Kafka effectively in OpenShift we need a way of giving some memory to the JVM, but also leaving plenty of memory available for use by the OS page cache.

OpenShift doesn't provide a single neat way to do this. What we can do is provide control over how much memory the JVM will use and simultaneously make use of OpenShift's resource requests and resource limits so that the pod gets schedules to a node with enough memory. Together these should be sufficient. 

    oc apply -f 06-with-resource-limits.yaml

## Prometheus metrics

AMQ Streams provides metrics exports for Prometheus. Users can plug it with their own Prometheus installation to monitor AMQ Streams. Prometheus is not included in this demo.

## Accessing fast disks

Obviously the nodes within an OpenShift cluster are not identical. The most important thing in getting a performant Kafka cluster is optimizing I/O. So we need to ensure that when OpenShift schedules broker pods it puts them on nodes with fast disks.

AMQ Stream on OpenShift supports this in exactly the same way that OpenShift itself does: Using pod affinity. If nodes with fast disks are all labelled appropriately I can express an affinity to nodes with that label in the Kafka resource.

Pod affinity does not guarantee that other I/O hungry workloads aren't going to get scheduled to the same nodes. If we know what those other workloads are, we can use pod antiaffinity to try to avoid our broker pods getting scheduled to nodes where those other workloads are already running.

**Because the demo is on a developer laptop, it's not possible to show this.**

## Dedicating nodes to Kafka

Sometimes node affinity and pod anitaffinity are not enough. The operator supports the same mechanism that OpenShift does to support dedicating nodes to a particular workload: Tolerations. 

Briefly the idea is that you select certain nodes and mark those with a taint. Normal workloads won't to scheduled to run on those nodes unless they declare that they can work on nodes with that taint. That declaration takes the form of a toleration.

**This functionality only works when nodes can be tainted.**

**Because the demo is on a developer laptop, it's not possible to show this.**

## Rack awareness

Kafka relies on having multiple copies of each partition in order to ensure messages are availably even when individual brokers are not available. These copies are called replicas.

On bare metal deployments if you tell Kafka what rack each broker is running in Kafka can avoid putting replicas of a partition on brokers running in the same rack. This avoids the situation where failure of a single rack can take down access to all of the replicas of a partition.

In OpenShift there isn't a physical rack to worry about, but nodes can still have correlated failure modes. In AWS, for example there is the concept of Availability Zone. Amazon doesn't promise anything about the availability of a single availability zone, so it would be problematic if all our brokers were scheduled to run in a single one.

AMQ Streams on OpenShift supports rack-aware scheduling to avoid this kind of problem.

**Because the demo is on a developer laptop, it's not possible to show this.**

## Scaling up Kafka

It's now time to scale up our cluster: We just have to change the `replicas` field in the desired resource to the number of brokers we want.

    oc edit kafka my-kafka
    # change spec.kafka.replicas to 3

Having made changes which require containers to be started or restarted we can watch as the operator deletes the pods and the statefulset creates new ones:

    oc get pods -w

## Adding the Entity Operator

Having set up a Kafka cluster we are ultimately going to want to use it to send and receive messages.
Before we can get there we are going to need to create a user within Kafka so our application can authenticate itself to the brokers.

AMQ Streams on OpenShift provides some other operators to make doing this simpler, and more OpenShift-esque.

The Topic Operator provides bidirectional synchronization between topics within Kafka and custom resources in OpenShift. 

The User Operator provides synchronization between a `KafkaUser` custom resource in OpenShift and Kafka's own user and Access Control List data structures. 

Together these operators allow the user to provision the topics and user accounts their application needs at the same time, and in the same way as the application itself: As OpenShift resources.

The Cluster Operator deploys these operators according to the configuration:

    oc apply -f 07-with-eo.yaml

The benefits here are:

* the usual benefits of doing things declaratively rather than imperitively
* users don't need to know all the Kafka tools in order to do these things
* it means that this configuration can be version controlled and fits well with things like gitops.

## Creating Topics & Users, running alient application

For this demo I'm going to need a single topic, which I create like this:

    oc apply -f 08-my-topic.yaml

I'm also going to need a single user, which I create like this:

    oc apply -f 09-my-user.yaml

For TLS authentication, the User Operator will create an X509 certificate for that user and sign it using an internal client Certificate Authority.
The client also needs to trust the broker's certificates, so we need to ensure the certificate of the CA which signed the broker certificate is in the clients' trust stores.

    cat 10-demo-application.yaml

With that in place we can create the applications

    oc apply -f 10-demo-application.yaml
    oc logs $(oc get pods -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | grep hello-world-producer)
    oc logs -f $(oc get pods -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | grep hello-world-consumer)

## Kafka Connect

Deploy the user for Kafka Connect.

    oc apply -f 11-my-connect.yaml

And deploy Kafka Connect.

    oc apply -f 12-kafka-connect.yaml

## Adding Kafka Connect connectors

Any additional connectors can be added to Kafka Connect using S2I.

    oc start-build my-connect-s2i-connect --from-dir 13-connect-plugins/ --follow

And deploy the connector.

    ./14-connector.yaml

Check the Kafka Connect logs to see the messages arriving.

    oc logs $(oc get pod -l app=tech-exchange-kafka-connect -o=jsonpath='{.items[0].metadata.name}') -f
