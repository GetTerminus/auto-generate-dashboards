# JVM Graphs
## Background
We are using the DD Java system agent to automatically collect tracing data and
JVM metrics. The agent instruments classes as they are loaded in order to
generate traces and it can also collect values exposed via JMX. Since we aren't
calling any code to configure (or use) DD, we set up the agent using environment
variables (`DD_TRACE_GLOBAL_TAGS` and `DD_SERVICE_NAME`).

## Dashboard Implementation
When the `--jvm-graphs` option is specified, each process that has the
`DD_SERVICE_NAME` environment variable defined in `docker-compose.convox.yml`
will have two additional graphs added to the service dashboard; one containing
the JVM heap size and one containing garbage collection times.
