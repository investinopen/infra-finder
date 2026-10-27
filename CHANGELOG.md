# Changelog

## 1.0.0 (2026-10-27)


### Features

* **cache:** replace the Redis cache store with Solid Cache ([20f0ea1](https://github.com/investinopen/infra-finder/commit/20f0ea13effe959e0ff0b1b85825677b70787842))
* **deploy:** add Kamal deployment for next and stg ([e2a5f13](https://github.com/investinopen/infra-finder/commit/e2a5f134a704a057d9b7fce7b67b0208367caddd))
* **deps:** upgrade to Rails 8.1 and update all gems ([973da97](https://github.com/investinopen/infra-finder/commit/973da971c319975bffee6730425b4dddfe68e71e))
* **good_job:** move GoodJob to a separate queue database ([90b2a00](https://github.com/investinopen/infra-finder/commit/90b2a007ef262f05f75595b24e1331b469b4361a))
* **sessions:** store sessions in the database ([4869aaf](https://github.com/investinopen/infra-finder/commit/4869aaf90bc2e05bafc047bbcb06b7d7f152c3f1))


### Bug Fixes

* **cache:** use the cache database in staging ([f2e5132](https://github.com/investinopen/infra-finder/commit/f2e5132a5fca80a0b278f21acc0b8e160bac6d50))
* **ci:** run checks on ready_for_review, dispatch, and main pushes ([c799e98](https://github.com/investinopen/infra-finder/commit/c799e9869f58142c912ebe3f64ccb5973b916403))
* **ci:** serialize deploys to the shared pre-production droplet ([6eaeed0](https://github.com/investinopen/infra-finder/commit/6eaeed039e55848dc3f67d09d43ee1c397c3b902))
* **deploy:** run deploy tasks from the container entrypoint ([8e6a18f](https://github.com/investinopen/infra-finder/commit/8e6a18f1e3ef9823a23cb0e4887281e73c8169fe))
* **docker:** keep stdin open for assets container ([83ef7ab](https://github.com/investinopen/infra-finder/commit/83ef7ab8b7841abf1632dd886ceb5298f88f6042))
* **docker:** start spec container after migrations run ([d87b3fd](https://github.com/investinopen/infra-finder/commit/d87b3fd6995ae4809ca6376cade1942eb6c9ce19))
* ensure properties are only rendered once in forms ([c0052cb](https://github.com/investinopen/infra-finder/commit/c0052cb809799af382e6a22f7d6d3a56a138fb5d))
* **errors:** serve error page assets from the app ([940b6b8](https://github.com/investinopen/infra-finder/commit/940b6b83c4fd1e4488707fa10c1ecafc569f88b4))
* **puma:** remove failing Redis cache disconnect from fork hook ([be9796e](https://github.com/investinopen/infra-finder/commit/be9796ee895c70a0f8ceed4cd38715a413a46a85))
* **staging:** silence health checks and use https in error pages ([552a7fe](https://github.com/investinopen/infra-finder/commit/552a7fe9665bad4a4e574c26cae4afa279a3f849))
