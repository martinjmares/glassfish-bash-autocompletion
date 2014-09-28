Bash command line autocompletion for GlassFish 4.1
==================================

## Glassfish 4.0 and older versions

Full featured autocompletion is created only for GlassFish 4.1 but most features
(most command and its parameters) are same in GlassFish 4 and older.

Special functions like dynamic completion base of actual GlassFish state will not correctly work for older versions
then GlassFish 4.

## About
If you are using GlassFish 4.1 CLI (asadmin utility) on bash then you can do TAB or TAB-TAB for autocomplete your
command line - including: command names, parameters and sometimes also values.

## Download

Best is to clone the git: [https://github.com/martinjmares/glassfish-bash-autocompletion.git](https://github.com/martinjmares/glassfish-bash-autocompletion.git)

Or you can also download raw file of your choice. Please see **Main features** to select your favorite distribution.
* **completion_asadmin_4.1fad.bash** = GlassFish 4.1 full profile with dynamic and abbreviations support
* **completion_asadmin_4.1fd.bash** = GlassFish 4.1 full profile with dynamic
* **completion_asadmin_4.1fa.bash** = GlassFish 4.1 full profile withabbreviations support
* **completion_asadmin_4.1f.bash** = GlassFish 4.1 full profile
* **completion_asadmin_4.1wad.bash** = GlassFish 4.1 web profile with dynamic and abbreviations support
* **completion_asadmin_4.1wd.bash** = GlassFish 4.1 web profile with dynamic
* **completion_asadmin_4.1wa.bash** = GlassFish 4.1 web profile withabbreviations support
* **completion_asadmin_4.1w.bash** = GlassFish 4.1 web profile

## Install

Simply _source_ provided script into your current TTY. Of course you can do it in your _.bashrc_ or _.profile_ file.

~~~
source completion_asadmin_{version}.bash
//OR
. completion_asadmin_{version}.bash
~~~

Some Linux distributions contains standard directory for completion scripts which are automatically sourced into TTYs.
Directory */etc/bash_completion.d* is quite popular.

## Main features

* Completes command names: _asadmin deplo&lt;TAB&gt;_
* Completes asadmin parameters: _asadmin --passwor&lt;TAB&gt;_
* Completes command parameter names: _asadmin deploy --&lt;TAB&gt;&lt;TAB&gt;_
* Completes parameter **names** only on correct position. It means not if parameter **value** is expected.
* Offers parameter name only if it was not used on other place of the same command line. Not applied on multi-parameters (new feature of GlassFish 4 CLI).
* **Dynamic distribution** : Completes operands and parameter values for some cases based on data dynamically reached from actual glassfishconfiguration:
    * _asadmin undeploy &lt;TAB&gt;&lt;TAB&gt;_ - will offer list of deployed applications
    * _asadmin start-cluster &lt;TAB&gt;&lt;TAB&gt;_  - will offer list of defined clusters, ...
* **Abbreviation distribution** : A lot of command names has standar abbreviation. If you type exactly selected abbreviation and press &lt;TAB&gt; then full value will be completed: _cli_ = _create-local-instance_

## Abbreviations

Here is full list of supported command abbreviations

### Full profile

* **add-library** - alb
* **add-resources** - ar
* **apply-http-lb-changes** - ahttplc
* **attach** - ttch
* **backup-domain** - bd
* **change-admin-password** - cap
* **change-master-broker** - cmb
* **change-master-password** - cmp
* **collect-log-files** - clf
* **configure-jms-cluster** - cjmsc
* **configure-lb-weight** - clw
* **configure-ldap-for-admin** - clfa
* **configure-managed-jobs** - cmj
* **copy-config** - cconf
* **create-admin-object** - cao
* **create-application-ref** - caref
* **create-audit-module** - cam
* **create-auth-realm** - crlm
* **create-cluster** - cc
* **create-connector-connection-pool** - cccp
* **create-connector-resource** - cconr, cconres
* **create-connector-security-map** - ccsm
* **create-connector-work-security-map** - ccwsm
* **create-context-service** - ccs
* **create-custom-resource** - ccr, ccres
* **create-domain** - cd
* **create-file-user** - cfu
* **create-http** - chttp
* **create-http-health-checker** - chttphc
* **create-http-lb** - chttplb
* **create-http-lb-config** - chttplc
* **create-http-lb-ref** - chttplr
* **create-http-listener** - chttpl
* **create-http-redirect** - chttpr
* **create-iiop-listener** - cil
* **create-instance** - ci
* **create-jacc-provider** - cjp
* **create-javamail-resource** - cjmr
* **create-jdbc-connection-pool** - cjdbccp
* **create-jdbc-resource** - cjdbcr
* **create-jms-host** - cjmsh
* **create-jms-resource** - cjmsr
* **create-jmsdest** - cj
* **create-jndi-resource** - cjndir
* **create-jvm-options** - cjo
* **create-lifecycle-module** - clm
* **create-local-instance** - cli
* **create-managed-executor-service** - cmes
* **create-managed-scheduled-executor-service** - cmses
* **create-managed-thread-factory** - cmtf
* **create-message-security-provider** - cmsp
* **create-module-config** - cmc
* **create-network-listener** - cnl
* **create-node-config** - cnc
* **create-node-dcom** - cnd
* **create-node-ssh** - cns
* **create-password-alias** - cpa
* **create-resource-adapter-config** - crac
* **create-resource-ref** - crr
* **create-service** - cs
* **create-ssl** - cssl
* **create-system-properties** - csp
* **create-threadpool** - ctp
* **create-transport** - ct
* **create-virtual-server** - cvs
* **delete-admin-object** - dao
* **delete-application-ref** - daref
* **delete-audit-module** - dam
* **delete-auth-realm** - drlm
* **delete-cluster** - dc
* **delete-config** - dconf
* **delete-connector-connection-pool** - dccp
* **delete-connector-resource** - dconr, dconres
* **delete-connector-security-map** - dcsm
* **delete-connector-work-security-map** - dcwsm
* **delete-context-service** - dcs
* **delete-custom-resource** - dcr, dcres
* **delete-domain** - dd
* **delete-file-user** - dfu
* **delete-http** - dhttp
* **delete-http-health-checker** - dhttphc
* **delete-http-lb** - dhttplb
* **delete-http-lb-config** - dhttplc
* **delete-http-lb-ref** - dhttplr
* **delete-http-listener** - dhttpl
* **delete-http-redirect** - dhttpr
* **delete-iiop-listener** - dil
* **delete-instance** - dinst
* **delete-jacc-provider** - djp
* **delete-javamail-resource** - djr
* **delete-jdbc-connection-pool** - djdbccp
* **delete-jdbc-resource** - djdbcr
* **delete-jms-host** - djmsh
* **delete-jms-resource** - djmsr
* **delete-jmsdest** - dj
* **delete-jndi-resource** - djndir
* **delete-jvm-options** - djo
* **delete-lifecycle-module** - dlm
* **delete-local-instance** - dli
* **delete-log-levels** - dll
* **delete-managed-executor-service** - dmes
* **delete-managed-scheduled-executor-service** - dmses
* **delete-managed-thread-factory** - dmtf
* **delete-message-security-provider** - dmsp
* **delete-module-config** - dmc
* **delete-network-listener** - dnl
* **delete-node-config** - dnc
* **delete-node-dcom** - dnd
* **delete-node-ssh** - dns
* **delete-password-alias** - dpa
* **delete-resource-adapter-config** - drac
* **delete-resource-ref** - drr
* **delete-ssl** - ds
* **delete-system-property** - dsp
* **delete-threadpool** - dtp
* **delete-transport** - dt
* **delete-virtual-server** - dvs
* **deploy** - dpl
* **deploydir** - dpldr
* **disable** - dsbl
* **disable-http-lb-application** - dhttpla
* **disable-http-lb-server** - dhttpls
* **disable-monitoring** - dm
* **disable-secure-admin** - dsa
* **disable-secure-admin-internal-user** - dsaiu
* **disable-secure-admin-principal** - dsap
* **enable** - nbl
* **enable-http-lb-application** - ehttpla
* **enable-http-lb-server** - ehttpls
* **enable-monitoring** - em
* **enable-secure-admin** - esa
* **enable-secure-admin-internal-user** - esaiu
* **enable-secure-admin-principal** - esap
* **export** - xprt
* **export-http-lb-config** - ehttplc
* **export-sync-bundle** - esb
* **flush-connection-pool** - fcp
* **flush-jmsdest** - fj
* **freeze-transaction-service** - fts
* **generate-domain-schema** - gds
* **generate-jvm-report** - gjr
* **get** - gt
* **get-active-module-config** - gamc
* **get-client-stubs** - gcs
* **get-health** - gh
* **help** - hlp
* **import-sync-bundle** - isb
* **install-node-dcom** - ind
* **jms-ping** - jmsp
* **list** - lst
* **list-admin-objects** - lao
* **list-application-refs** - laref
* **list-applications** - la
* **list-audit-modules** - lam
* **list-auth-realms** - lrlm
* **list-backups** - lb
* **list-batch-job-executions** - lbje
* **list-batch-job-steps** - lbjs
* **list-batch-jobs** - lbj
* **list-batch-runtime-configuration** - lbrc
* **list-clusters** - lc
* **list-commands** - lcmd
* **list-components** - lcmp
* **list-configs** - lconf
* **list-connector-connection-pools** - lccp
* **list-connector-security-maps** - lcsm
* **list-connector-work-security-maps** - lcwsm
* **list-context-services** - lcs
* **list-domains** - ld
* **list-file-groups** - lfg
* **list-file-users** - lfu
* **list-http-lb-configs** - lhttplc
* **list-http-lbs** - lhttplb
* **list-http-listeners** - lhttplist
* **list-iiop-listeners** - lil
* **list-instances** - linst
* **list-jacc-providers** - ljp
* **list-javamail-resources** - ljmr
* **list-jdbc-connection-pools** - ljdbccp
* **list-jdbc-resources** - ljdbcr
* **list-jms-hosts** - ljmsh
* **list-jms-resources** - ljmsr
* **list-jndi-entries** - ljndie
* **list-jndi-resources** - ljndir
* **list-jvm-options** - ljo
* **list-libraries** - llb
* **list-lifecycle-modules** - llm
* **list-log-attributes** - lla
* **list-log-levels** - lll
* **list-loggers** - llg, llog
* **list-managed-executor-services** - lmes
* **list-managed-scheduled-executor-services** - lmses
* **list-managed-thread-factories** - lmtf
* **list-message-security-providers** - lmsp
* **list-modules** - lm
* **list-network-listeners** - lnl
* **list-nodes** - ln
* **list-nodes-config** - lnc
* **list-nodes-dcom** - lnd
* **list-nodes-ssh** - lns
* **list-password-aliases** - lpa
* **list-persistence-types** - lpt
* **list-protocols** - lp
* **list-resource-adapter-configs** - lrac
* **list-resource-refs** - lrr
* **list-secure-admin-internal-users** - lsaiu
* **list-secure-admin-principals** - lsap
* **list-sub-components** - lsc
* **list-supported-cipher-suites** - lscs
* **list-system-properties** - lsp
* **list-threadpools** - ltp
* **list-virtual-servers** - lvs
* **list-web-context-param** - lwcp
* **list-web-env-entry** - lwee
* **login** - lgn
* **migrate-timers** - mt
* **monitor** - mntr
* **multimode** - mltmd
* **osgi** - sg
* **ping-connection-pool** - pcp
* **ping-node-dcom** - pnd
* **ping-node-ssh** - pns
* **recover-transactions** - rt
* **redeploy** - rdpl
* **remove-library** - rlb, rlib
* **restart-domain** - rsd
* **restart-instance** - rsi
* **restart-local-instance** - rsli
* **restore-domain** - rstd
* **rollback-transaction** - rbt
* **rotate-log** - rl
* **set-batch-runtime-configuration** - sbrc
* **set-log-attributes** - sla
* **set-log-file-format** - slff
* **set-log-levels** - sll
* **set-web-context-param** - swcp
* **set-web-env-entry** - swee
* **setup-local-dcom** - sld
* **setup-ssh** - ss
* **show-component-status** - scs
* **start-cluster** - sc
* **start-database** - sdb
* **start-domain** - sd
* **start-instance** - si
* **start-local-instance** - sli
* **stop-cluster** - stpc
* **stop-database** - stpdb
* **stop-domain** - stpd
* **stop-instance** - stpi
* **stop-local-instance** - stpli
* **undeploy** - udpl, undpl
* **unfreeze-transaction-service** - uts
* **uninstall-node** - unn
* **unset** - nst
* **unset-web-context-param** - uwcp
* **unset-web-env-entry** - uwee
* **update-connector-security-map** - ucsm
* **update-connector-work-security-map** - ucwsm
* **update-file-user** - ufu
* **update-node-config** - unc
* **update-password-alias** - upa
* **uptime** - ptm
* **validate-dcom** - vd
* **validate-multicast** - vm
* **verify-domain-xml** - vdx
* **version** - vrsn

### Web Profile

* **add-library** - alb
* **add-resources** - ar
* **apply-http-lb-changes** - ahttplc
* **attach** - ttch
* **backup-domain** - bd
* **change-admin-password** - cap
* **change-master-password** - cmp
* **collect-log-files** - clf
* **configure-lb-weight** - clw
* **configure-ldap-for-admin** - clfa
* **configure-managed-jobs** - cmj
* **copy-config** - cconf
* **create-admin-object** - cao
* **create-application-ref** - caref
* **create-audit-module** - cam
* **create-auth-realm** - crlm
* **create-cluster** - cc
* **create-connector-connection-pool** - cccp
* **create-connector-resource** - cconr, cconres
* **create-connector-security-map** - ccsm
* **create-connector-work-security-map** - ccwsm
* **create-custom-resource** - ccr, ccres
* **create-domain** - cd
* **create-file-user** - cfu
* **create-http** - chttp
* **create-http-health-checker** - chttphc
* **create-http-lb** - chttplb
* **create-http-lb-config** - chttplc
* **create-http-lb-ref** - chttplr
* **create-http-listener** - chttpl
* **create-http-redirect** - chttpr
* **create-iiop-listener** - cil
* **create-instance** - ci
* **create-jacc-provider** - cjp
* **create-javamail-resource** - cjmr
* **create-jdbc-connection-pool** - cjdbccp
* **create-jdbc-resource** - cjdbcr
* **create-jndi-resource** - cjndir
* **create-jvm-options** - cjo
* **create-lifecycle-module** - clm
* **create-local-instance** - cli
* **create-message-security-provider** - cmsp
* **create-module-config** - cmc
* **create-network-listener** - cnl
* **create-node-config** - cnc
* **create-node-dcom** - cnd
* **create-node-ssh** - cns
* **create-password-alias** - cpa
* **create-resource-adapter-config** - crac
* **create-resource-ref** - crr
* **create-service** - cs
* **create-ssl** - cssl
* **create-system-properties** - csp
* **create-threadpool** - ctp
* **create-transport** - ct
* **create-virtual-server** - cvs
* **delete-admin-object** - dao
* **delete-application-ref** - daref
* **delete-audit-module** - dam
* **delete-auth-realm** - drlm
* **delete-cluster** - dc
* **delete-config** - dconf
* **delete-connector-connection-pool** - dccp
* **delete-connector-resource** - dconr, dconres
* **delete-connector-security-map** - dcsm
* **delete-connector-work-security-map** - dcwsm
* **delete-custom-resource** - dcr, dcres
* **delete-domain** - dd
* **delete-file-user** - dfu
* **delete-http** - dhttp
* **delete-http-health-checker** - dhttphc
* **delete-http-lb** - dhttplb
* **delete-http-lb-config** - dhttplc
* **delete-http-lb-ref** - dhttplr
* **delete-http-listener** - dhttpl
* **delete-http-redirect** - dhttpr
* **delete-iiop-listener** - dil
* **delete-instance** - dinst
* **delete-jacc-provider** - djp
* **delete-javamail-resource** - djr
* **delete-jdbc-connection-pool** - djdbccp
* **delete-jdbc-resource** - djdbcr
* **delete-jndi-resource** - djndir
* **delete-jvm-options** - djo
* **delete-lifecycle-module** - dlm
* **delete-local-instance** - dli
* **delete-log-levels** - dll
* **delete-message-security-provider** - dmsp
* **delete-module-config** - dmc
* **delete-network-listener** - dnl
* **delete-node-config** - dnc
* **delete-node-dcom** - dnd
* **delete-node-ssh** - dns
* **delete-password-alias** - dpa
* **delete-resource-adapter-config** - drac
* **delete-resource-ref** - drr
* **delete-ssl** - ds
* **delete-system-property** - dsp
* **delete-threadpool** - dtp
* **delete-transport** - dt
* **delete-virtual-server** - dvs
* **deploy** - dpl
* **deploydir** - dpldr
* **disable** - dsbl
* **disable-http-lb-application** - dhttpla
* **disable-http-lb-server** - dhttpls
* **disable-monitoring** - dm
* **disable-secure-admin** - dsa
* **disable-secure-admin-internal-user** - dsaiu
* **disable-secure-admin-principal** - dsap
* **enable** - nbl
* **enable-http-lb-application** - ehttpla
* **enable-http-lb-server** - ehttpls
* **enable-monitoring** - em
* **enable-secure-admin** - esa
* **enable-secure-admin-internal-user** - esaiu
* **enable-secure-admin-principal** - esap
* **export** - xprt
* **export-http-lb-config** - ehttplc
* **export-sync-bundle** - esb
* **flush-connection-pool** - fcp
* **freeze-transaction-service** - fts
* **generate-domain-schema** - gds
* **generate-jvm-report** - gjr
* **get** - gt
* **get-active-module-config** - gamc
* **get-client-stubs** - gcs
* **get-health** - gh
* **help** - hlp
* **import-sync-bundle** - isb
* **install-node-dcom** - ind
* **list** - lst
* **list-admin-objects** - lao
* **list-application-refs** - laref
* **list-applications** - la
* **list-audit-modules** - lam
* **list-auth-realms** - lrlm
* **list-backups** - lb
* **list-clusters** - lc
* **list-commands** - lcmd
* **list-components** - lcmp
* **list-configs** - lconf
* **list-connector-connection-pools** - lccp
* **list-connector-security-maps** - lcsm
* **list-connector-work-security-maps** - lcwsm
* **list-domains** - ld
* **list-file-groups** - lfg
* **list-file-users** - lfu
* **list-http-lb-configs** - lhttplc
* **list-http-lbs** - lhttplb
* **list-http-listeners** - lhttplist
* **list-iiop-listeners** - lil
* **list-instances** - linst
* **list-jacc-providers** - ljp
* **list-javamail-resources** - ljmr
* **list-jdbc-connection-pools** - ljdbccp
* **list-jdbc-resources** - ljdbcr
* **list-jndi-entries** - ljndie
* **list-jndi-resources** - ljndir
* **list-jobs** - lj
* **list-jvm-options** - ljo
* **list-libraries** - llb
* **list-lifecycle-modules** - llm
* **list-log-attributes** - lla
* **list-log-levels** - lll
* **list-loggers** - llg, llog
* **list-message-security-providers** - lmsp
* **list-modules** - lm
* **list-network-listeners** - lnl
* **list-nodes** - ln
* **list-nodes-config** - lnc
* **list-nodes-dcom** - lnd
* **list-nodes-ssh** - lns
* **list-password-aliases** - lpa
* **list-persistence-types** - lpt
* **list-protocols** - lp
* **list-resource-adapter-configs** - lrac
* **list-resource-refs** - lrr
* **list-secure-admin-internal-users** - lsaiu
* **list-secure-admin-principals** - lsap
* **list-sub-components** - lsc
* **list-supported-cipher-suites** - lscs
* **list-system-properties** - lsp
* **list-threadpools** - ltp
* **list-virtual-servers** - lvs
* **list-web-context-param** - lwcp
* **list-web-env-entry** - lwee
* **login** - lgn
* **migrate-timers** - mt
* **monitor** - mntr
* **multimode** - mltmd
* **osgi** - sg
* **ping-connection-pool** - pcp
* **ping-node-dcom** - pnd
* **ping-node-ssh** - pns
* **recover-transactions** - rt
* **redeploy** - rdpl
* **remove-library** - rlb, rlib
* **restart-domain** - rsd
* **restart-instance** - rsi
* **restart-local-instance** - rsli
* **restore-domain** - rstd
* **rollback-transaction** - rbt
* **rotate-log** - rl
* **set-log-attributes** - sla
* **set-log-file-format** - slff
* **set-log-levels** - sll
* **set-web-context-param** - swcp
* **set-web-env-entry** - swee
* **setup-local-dcom** - sld
* **setup-ssh** - ss
* **show-component-status** - scs
* **start-cluster** - sc
* **start-database** - sdb
* **start-domain** - sd
* **start-instance** - si
* **start-local-instance** - sli
* **stop-cluster** - stpc
* **stop-database** - stpdb
* **stop-domain** - stpd
* **stop-instance** - stpi
* **stop-local-instance** - stpli
* **undeploy** - udpl, undpl
* **unfreeze-transaction-service** - uts
* **uninstall-node** - unn
* **unset** - nst
* **unset-web-context-param** - uwcp
* **unset-web-env-entry** - uwee
* **update-connector-security-map** - ucsm
* **update-connector-work-security-map** - ucwsm
* **update-file-user** - ufu
* **update-node-config** - unc
* **update-password-alias** - upa
* **uptime** - ptm
* **validate-dcom** - vd
* **validate-multicast** - vm
* **verify-domain-xml** - vdx
* **version** - vrsn
