openstack-tracing
=================

patches to add tracing to folsom.

## Getting started

1. install the latest oboe python module http://support.tracelytics.com/kb/python/installing-python-instrumentation
2. apply patches in /patches to each desired repo (you want all of them!)
3. edit the configs for keystone and cinder as described below

### Keystone config

Declare as following in /etc/keystone.conf:

```
[filter:oboe]
paste.filter_factory = keystone.contrib.oboe:KeystoneOboeMiddleware.factory

Then include in all pipelines, eg:

[pipeline:public_api]
pipeline = oboe stats_monitoring url_normalize token_auth admin_token_auth xml_body json_body debug ec2_extension user_crud_extension public_service

[pipeline:admin_api]
pipeline = oboe stats_monitoring url_normalize token_auth admin_token_auth xml_body json_body debug stats_reporting ec2_extension s3_extension crud_extension admin_service

[pipeline:public_version_api]
pipeline = oboe stats_monitoring url_normalize xml_body public_version_service

[pipeline:admin_version_api]
pipeline = oboe stats_monitoring url_normalize xml_body admin_version_service
```

### Cinder config

Declare as following in /etc/cinder/api-paste.conf:

```
[filter:oboe]
paste.filter_factory = cinder.contrib.oboe:CinderOboeMiddleware.factory

Then use in all pipelines:

[composite:openstack_volume_api_v1]
use = call:cinder.api.auth:pipeline_factory
noauth = oboe faultwrap sizelimit noauth osapi_volume_app_v1
keystone = oboe faultwrap sizelimit authtoken keystonecontext osapi_volume_app_v1
keystone_nolimit = oboe faultwrap sizelimit authtoken keystonecontext osapi_volume_app_v1

[pipeline:osvolumeversions]
pipeline = oboe faultwrap osvolumeversionapp
```
