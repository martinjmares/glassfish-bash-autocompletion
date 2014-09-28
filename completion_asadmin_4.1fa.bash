#!/bin/sh

# ----------------------------------------------------------------------------
# "THE BEER-WARE LICENSE" (Revision 42):
# <martin.jacek.mares@gmail.com> wrote this file. As long as you retain this
# notice you can do whatever you want with this stuff. If we meet some day,
# and you think this stuff is worth it, you can buy me a beer in return
# Martin Mares
# ----------------------------------------------------------------------------



_nclnac_containsElement () {
  local e
  for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
  return 1
}

_nclnac_addNonexistMulti () {
    local melem selem cmpw findone
    for melem in "${@:1}" ; do
        findone=false
        for selem in $melem ; do
            for cmpw in "${COMP_WORDS[@]}" ; do
                if [[ "$selem" == "$cmpw" ]] ; then
                    findone=true
                    break
                fi
            done
            if $findone ; then
                break
            fi
        done
        if ! $findone ; then
            COMPPOSIB=( ${COMPPOSIB[@]} $melem )
        fi
    done
}


_nclnac_asadmin () {
    local cur prev comp commandisdefined tempreply
    COMPREPLY=()
    COMPPOSIB=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    #Variables
    if [[ $cur == \$* ]] ; then
        tempreply=( $(compgen -v ${cur:1}) )
        COMPREPLY=( ${tempreply[@]/#/$} )
        return 0
    fi
    #General attributes of asadmin
    _nclnac_addNonexistMulti "--help"
    #Search for command
    commandisdefined=false
    for comp in ${COMP_WORDS[*]:1} ; do
        if [[ "$comp" != "$cur" ]] && [[ $comp != -* ]] ; then
            case "$comp" in
                'add-library')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--upload" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--type" "--upload" 
                    ;;
                'add-resources')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--upload" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" "--upload" 
                    ;;
                'apply-http-lb-changes')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--ping" 
                    ;;
                'attach')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    ;;
                'backup-domain')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--description" "--long --verbose -l" "--backupConfig" "--backupdir" "--domaindir" 
                    ;;
                'change-admin-password')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--domain_name" "--password" "--newpassword" "--domaindir" 
                    ;;
                'change-master-broker')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    ;;
                'change-master-password')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--savemasterpassword" "--nodedir" "--domaindir" 
                    ;;
                'collect-log-files')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--retrieve" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" "--retrieve" 
                    ;;
                'configure-jms-cluster')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--configstoretype --cs" "--messagestoretype --ms" "--clustertype --ct" "--dbvendor --db" "--dbuser --user" "--jmsDbPassword" "--dburl --url" "--property" 
                    ;;
                'configure-lb-weight')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--cluster" 
                    ;;
                'configure-ldap-for-admin')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--basedn -b" "--url" "--ldap-group -g" "--target" 
                    ;;
                'configure-managed-jobs')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--in-memory-retention-period" "--job-retention-period" "--cleanup-initial-delay" "--cleanup-poll-interval" 
                    ;;
                'copy-config')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--systemproperties" 
                    ;;
                'create-admin-object')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--enabled" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--restype" "--classname" "--raname --resAdapter" "--enabled" "--description" "--property" "--target" 
                    ;;
                'create-application-ref')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--enabled" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" "--virtualservers" "--enabled" "--lbenabled" 
                    ;;
                'create-audit-module')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--classname" "--property" "--target" 
                    ;;
                'create-auth-realm')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--classname" "--property" "--target" 
                    ;;
                'create-cluster')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--haadminpasswordfile" "--haadminpassword" "--properties" "--multicastport --heartbeatport" "--systemproperties" "--haagentport" "--bindaddress" "--portbase" "--haproperty" "--gmsenabled" "--multicastaddress --heartbeataddress" "--devicesize" "--autohadb" "--gmsbroadcast" "--hosts" "--config" 
                    ;;
                'create-connector-connection-pool')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--isconnectvalidatereq" "--isConnectionValidationRequired" "--failconnection" "--failAllConnections" "--leakreclaim" "--connectionLeakReclaim" "--lazyconnectionenlistment" "--lazyConnectionEnlistment" "--lazyconnectionassociation" "--lazyConnectionAssociation" "--associatewiththread" "--associateWithThread" "--matchconnections" "--matchConnections" "--ping" "--pooling" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--raname --resourceAdapterName" "--connectiondefinition --connectiondefinitionname" "--steadypoolsize --steadyPoolSize" "--maxpoolsize --maxPoolSize" "--maxwait --maxWaitTimeInMillis" "--poolresize --poolResizeQuantity" "--idletimeout --idleTimeoutInSeconds" "--isconnectvalidatereq --isConnectionValidationRequired" "--failconnection --failAllConnections" "--leaktimeout --connectionLeakTimeoutInSeconds" "--leakreclaim --connectionLeakReclaim" "--creationretryattempts --connectionCreationRetryAttempts" "--creationretryinterval --connectionCreationRetryIntervalInSeconds" "--lazyconnectionenlistment --lazyConnectionEnlistment" "--lazyconnectionassociation --lazyConnectionAssociation" "--associatewiththread --associateWithThread" "--matchconnections --matchConnections" "--maxconnectionusagecount --maxConnectionUsageCount" "--ping" "--pooling" "--validateatmostonceperiod --validateAtmostOncePeriodInSeconds" "--transactionsupport --transactionSupport" "--description" "--property" "--target" 
                    ;;
                'create-connector-resource')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--enabled" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--poolname" "--enabled" "--description" "--objecttype" "--property" "--target" 
                    ;;
                'create-connector-security-map')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" "--poolname" "--principals" "--usergroups" "--mappedusername" "--mappedpassword" 
                    ;;
                'create-connector-work-security-map')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--raname" "--principalsmap" "--groupsmap" "--description" 
                    ;;
                'create-context-service')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--enabled" "--contextinfoenabled" "--contextInfoEnabled" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--enabled" "--contextinfoenabled --contextInfoEnabled" "--contextinfo --contextInfo" "--description" "--property" "--target" 
                    ;;
                'create-custom-resource')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--enabled" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--restype" "--factoryclass" "--enabled" "--description" "--property" "--target" 
                    ;;
                'create-domain')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--adminport" "--portbase" "--profile" "--template" "--domaindir" "--instanceport" "--savemasterpassword" "--usemasterpassword" "--domainproperties" "--keytooloptions" "--savelogin" "--nopassword" "--password" "--masterpassword" "--checkports" 
                    ;;
                'create-file-user')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--groups" "--userpassword" "--authrealmname" "--target" 
                    ;;
                'create-http')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--dns-lookup-enabled" "--dnsLookupEnabled" "--xpowered" "--xpoweredBy" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--request-timeout-seconds --requestTimeoutSeconds" "--timeout-seconds --timeoutSeconds" "--max-connection --maxConnections" "--default-virtual-server --defaultVirtualServer" "--dns-lookup-enabled --dnsLookupEnabled" "--servername --serverName" "--xpowered --xpoweredBy" "--target" 
                    ;;
                'create-http-health-checker')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--timeout" "--interval" "--url" "--config" 
                    ;;
                'create-http-lb')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--httpsrouting" "--monitor" "--routecookie" "--autoapplyenabled" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--devicehost" "--deviceport" "--target" "--sslproxyhost" "--sslproxyport" "--lbpolicy" "--lbpolicymodule" "--healthcheckerurl" "--healthcheckerinterval" "--healthcheckertimeout" "--lbenableallinstances" "--lbenableallapplications" "--lbweight" "--responsetimeout" "--httpsrouting" "--reloadinterval" "--monitor" "--routecookie" "--autoapplyenabled" "--property" 
                    ;;
                'create-http-lb-config')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--responsetimeout" "--monitor" "--httpsrouting" "--target" "--property" "--routecookie" "--reloadinterval" 
                    ;;
                'create-http-lb-ref')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--config" "--lbname" "--lbpolicy" "--lbpolicymodule" "--healthcheckerurl" "--healthcheckerinterval" "--healthcheckertimeout" "--lbenableallapplications" "--lbenableallinstances" "--lbweight" 
                    ;;
                'create-http-listener')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--xpowered" "--securityenabled" "--enabled" "--secure" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--listeneraddress" "--listenerport" "--defaultvs" "--default-virtual-server" "--servername" "--xpowered" "--acceptorthreads" "--redirectport" "--securityenabled" "--enabled" "--secure" "--target" 
                    ;;
                'create-http-redirect')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--redirect-port" "--secure-redirect" "--target" 
                    ;;
                'create-iiop-listener')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--enabled" "--securityenabled" "--security-enabled" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" "--listeneraddress --address" "--iiopport --port" "--enabled" "--securityenabled --security-enabled" "--property" 
                    ;;
                'create-instance')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--lbenabled" "--checkports" "--terse" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--node --nodeagent" "--config" "--cluster" "--lbenabled" "--checkports" "--terse" "--portbase" "--systemproperties" 
                    ;;
                'create-jacc-provider')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--policyconfigfactoryclass --policyConfigurationFactoryProvider" "--policyproviderclass --policyProvider" "--property" "--target" 
                    ;;
                'create-javamail-resource')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--enabled" "--debug" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--mailhost --host" "--mailuser --user" "--fromaddress --from" "--storeprotocol --storeProtocol" "--storeprotocolclass --storeProtocolClass" "--transprotocol --transportProtocol" "--transprotocolclass --transportProtocolClass" "--enabled" "--debug" "--property" "--target" "--description" 
                    ;;
                'create-jdbc-connection-pool')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--isIsolationGuaranteed" "--isIsolationLevelGuaranteed" "--isConnectValidateReq" "--isConnectionValidationRequired" "--failConnection" "--failAllConnections" "--allowNonComponentCallers" "--nonTransactionalConnections" "--leakReclaim" "--connectionLeakReclaim" "--statementLeakReclaim" "--statementLeakReclaim" "--lazyConnectionEnlistment" "--lazyConnectionAssociation" "--associateWithThread" "--matchConnections" "--ping" "--pooling" "--wrapJdbcObjects" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--datasourceClassname" "--resType" "--steadyPoolSize" "--maxPoolSize" "--maxWait --maxWaitTimeInMillis" "--poolResize --poolResizeQuantity" "--idleTimeout --idleTimeoutInSeconds" "--initSql" "--isolationLevel --transactionIsolationLevel" "--isIsolationGuaranteed --isIsolationLevelGuaranteed" "--isConnectValidateReq --isConnectionValidationRequired" "--validationMethod --connectionValidationMethod" "--validationTable --validationTableName" "--failConnection --failAllConnections" "--allowNonComponentCallers" "--nonTransactionalConnections" "--validateAtMostOncePeriod --validateAtmostOncePeriodInSeconds" "--leakTimeout --connectionLeakTimeoutInSeconds" "--leakReclaim --connectionLeakReclaim" "--creationRetryAttempts --connectionCreationRetryAttempts" "--creationRetryInterval --connectionCreationRetryIntervalInSeconds" "--sqlTraceListeners" "--statementTimeout --statementTimeoutInSeconds" "--statementLeakTimeout --statementLeakTimeoutInSeconds" "--statementLeakReclaim --statementLeakReclaim" "--lazyConnectionEnlistment" "--lazyConnectionAssociation" "--associateWithThread" "--driverClassname" "--matchConnections" "--maxConnectionUsageCount" "--ping" "--pooling" "--statementCacheSize" "--validationClassname" "--wrapJdbcObjects" "--description" "--property" "--target" 
                    ;;
                'create-jdbc-resource')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--enabled" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--connectionpoolid --poolName" "--enabled" "--description" "--property" "--target" 
                    ;;
                'create-jmsdest')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--force" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--destType -T" "--property" "--force" "--target" 
                    ;;
                'create-jms-host')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--force" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--mqHost --host" "--mqPort --port" "--mqUser --adminUserName" "--mqPassword --adminPassword" "--property" "--target" "--force" 
                    ;;
                'create-jms-resource')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--enabled" "--force" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--resType" "--enabled" "--property" "--target" "--description" "--force" 
                    ;;
                'create-jndi-resource')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--enabled" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--restype" "--factoryclass" "--jndilookupname" "--enabled" "--description" "--property" "--target" 
                    ;;
                'create-jvm-options')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--profiler" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" "--profiler" 
                    ;;
                'create-lifecycle-module')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--failurefatal" "--enabled" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--classname" "--classpath" "--loadorder" "--failurefatal" "--enabled" "--description" "--target" "--property" 
                    ;;
                'create-local-instance')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--lbenabled" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--config" "--cluster" "--lbenabled" "--systemproperties" "--portbase" "--checkports" "--savemasterpassword" "--usemasterpassword" "--nodedir --agentdir" "--node --nodeagent" 
                    ;;
                'create-managed-executor-service')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--enabled" "--contextinfoenabled" "--contextInfoEnabled" "--longrunningtasks" "--longRunningTasks" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--maximumpoolsize --maximumPoolSize" "--taskqueuecapacity --taskQueueCapacity" "--enabled" "--contextinfoenabled --contextInfoEnabled" "--contextinfo --contextInfo" "--threadpriority --threadPriority" "--longrunningtasks --longRunningTasks" "--hungafterseconds --hungAfterSeconds" "--corepoolsize --corePoolSize" "--keepaliveseconds --keepAliveSeconds" "--threadlifetimeseconds --threadLifetimeSeconds" "--description" "--property" "--target" 
                    ;;
                'create-managed-scheduled-executor-service')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--enabled" "--contextinfoenabled" "--contextInfoEnabled" "--longrunningtasks" "--longRunningTasks" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--enabled" "--contextinfoenabled --contextInfoEnabled" "--contextinfo --contextInfo" "--threadpriority --threadPriority" "--longrunningtasks --longRunningTasks" "--hungafterseconds --hungAfterSeconds" "--corepoolsize --corePoolSize" "--keepaliveseconds --keepAliveSeconds" "--threadlifetimeseconds --threadLifetimeSeconds" "--description" "--property" "--target" 
                    ;;
                'create-managed-thread-factory')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--enabled" "--contextinfoenabled" "--contextInfoEnabled" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--enabled" "--contextinfoenabled --contextInfoEnabled" "--contextinfo --contextInfo" "--threadpriority --threadPriority" "--description" "--property" "--target" 
                    ;;
                'create-message-security-provider')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--isdefaultprovider" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--layer" "--providertype" "--requestauthsource" "--requestauthrecipient" "--responseauthsource" "--responseauthrecipient" "--isdefaultprovider" "--property" "--classname" "--target" 
                    ;;
                'create-module-config')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--dryRun" "--all" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--dryRun" "--all" "--target" 
                    ;;
                'create-network-listener')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--enabled" "--jkenabled" "--jkEnabled" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--address" "--listenerport --Port" "--threadpool --threadPool" "--protocol" "--transport" "--enabled" "--jkenabled --jkEnabled" "--target" 
                    ;;
                'create-node-config')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--nodedir" "--nodehost" "--installdir" 
                    ;;
                'create-node-dcom')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--force" "--install" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--windowsuser -w" "--windowspassword" "--windowsdomain -d" "--nodehost" "--installdir" "--nodedir" "--force" "--install" "--archive" 
                    ;;
                'create-node-ssh')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--force" "--install" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--sshport" "--sshuser" "--sshpassword" "--sshkeyfile" "--sshkeypassphrase" "--nodehost" "--installdir" "--nodedir" "--force" "--install" "--archive" 
                    ;;
                'create-password-alias')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--aliaspassword" 
                    ;;
                'create-profiler')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--enabled" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--classpath" "--enabled" "--nativelibrarypath" "--property" "--target" 
                    ;;
                'create-protocol')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--securityenabled" "--securityEnabled" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--securityenabled --securityEnabled" "--target" 
                    ;;
                'create-protocol-filter')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--protocol" "--classname" "--target" 
                    ;;
                'create-protocol-finder')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--protocol" "--targetprotocol" "--classname" "--target" 
                    ;;
                'create-resource-adapter-config')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--property" "--target" "--threadpoolid --threadPoolIds" "--objecttype" 
                    ;;
                'create-resource-ref')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--enabled" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--enabled" "--target" 
                    ;;
                'create-service')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--name" "--serviceproperties" "--dry-run -n" "--force" "--domaindir" "--serviceuser" "--nodedir --agentdir" "--node --nodeagent" 
                    ;;
                'create-ssl')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--ssl2Enabled" "--ssl3Enabled" "--tlsEnabled" "--tlsRollbackEnabled" "--clientAuthEnabled" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--certname --certNickname" "--type" "--ssl2Enabled" "--ssl2Ciphers" "--ssl3Enabled" "--ssl3TlsCiphers" "--tlsEnabled" "--tlsRollbackEnabled" "--clientAuthEnabled" "--target" 
                    ;;
                'create-system-properties')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    ;;
                'create-threadpool')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--maxthreadpoolsize --maxThreadPoolSize" "--minthreadpoolsize --minThreadPoolSize" "--idletimeout --idleThreadTimeoutSeconds" "--workqueues" "--maxqueuesize --maxQueueSize" "--target" 
                    ;;
                'create-transport')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--displayconfiguration" "--displayConfiguration" "--enablesnoop" "--enableSnoop" "--tcpnodelay" "--tcpNoDelay" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--acceptorthreads --acceptorThreads" "--buffersizebytes --bufferSizeBytes" "--bytebuffertype --byteBufferType" "--classname" "--displayconfiguration --displayConfiguration" "--enablesnoop --enableSnoop" "--idlekeytimeoutseconds --idleKeyTimeoutSeconds" "--maxconnectionscount --maxConnectionsCount" "--readtimeoutmillis --readTimeoutMillis" "--writetimeoutmillis --writeTimeoutMillis" "--selectionkeyhandler --selectionKeyHandler" "--selectorpolltimeoutmillis --selectorPollTimeoutMillis" "--tcpnodelay --tcpNoDelay" "--target" 
                    ;;
                'create-virtual-server')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--hosts" "--httplisteners" "--networklisteners" "--defaultwebmodule" "--state" "--logfile" "--property" "--target" 
                    ;;
                'delete-admin-object')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    ;;
                'delete-application-ref')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--cascade" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" "--cascade" 
                    ;;
                'delete-audit-module')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    ;;
                'delete-auth-realm')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    ;;
                'delete-cluster')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--autohadboverride" "--nodeagent" 
                    ;;
                'delete-config')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    ;;
                'delete-connector-connection-pool')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--cascade" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" "--cascade" 
                    ;;
                'delete-connector-resource')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    ;;
                'delete-connector-security-map')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--poolname" "--target" 
                    ;;
                'delete-connector-work-security-map')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--raname" 
                    ;;
                'delete-context-service')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    ;;
                'delete-custom-resource')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    ;;
                'delete-domain')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--domaindir" 
                    ;;
                'delete-file-user')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--authrealmname" "--target" 
                    ;;
                'delete-http')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    ;;
                'delete-http-health-checker')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--config" 
                    ;;
                'delete-http-lb')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    ;;
                'delete-http-lb-config')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    ;;
                'delete-http-lb-ref')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--config" "--lbname" "--force" 
                    ;;
                'delete-http-listener')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--secure" "--target" 
                    ;;
                'delete-http-redirect')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    ;;
                'delete-iiop-listener')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    ;;
                'delete-instance')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--terse" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--terse" 
                    ;;
                'delete-jacc-provider')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    ;;
                'delete-javamail-resource')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    ;;
                'delete-jdbc-connection-pool')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--cascade" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--cascade" "--target" 
                    ;;
                'delete-jdbc-resource')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    ;;
                'delete-jmsdest')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--destType -T" "--target" 
                    ;;
                'delete-jms-host')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    ;;
                'delete-jms-resource')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    ;;
                'delete-jndi-resource')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    ;;
                'delete-jvm-options')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--profiler" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" "--profiler" 
                    ;;
                'delete-lifecycle-module')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    ;;
                'delete-local-instance')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--nodedir --agentdir" "--node --nodeagent" 
                    ;;
                'delete-log-levels')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    ;;
                'delete-managed-executor-service')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    ;;
                'delete-managed-scheduled-executor-service')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    ;;
                'delete-managed-thread-factory')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    ;;
                'delete-message-security-provider')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--layer" "--target" 
                    ;;
                'delete-module-config')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    ;;
                'delete-network-listener')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    ;;
                'delete-node-config')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    ;;
                'delete-node-dcom')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--uninstall" "--force" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--uninstall" "--force" 
                    ;;
                'delete-node-ssh')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--uninstall" "--force" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--uninstall" "--force" 
                    ;;
                'delete-password-alias')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    ;;
                'delete-profiler')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    ;;
                'delete-protocol')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    ;;
                'delete-protocol-filter')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--protocol" "--target" 
                    ;;
                'delete-protocol-finder')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--protocol" "--target" 
                    ;;
                'delete-resource-adapter-config')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    ;;
                'delete-resource-ref')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    ;;
                'delete-ssl')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--type" "--target" 
                    ;;
                'delete-system-property')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    ;;
                'delete-threadpool')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    ;;
                'delete-transport')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    ;;
                'delete-virtual-server')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    ;;
                'deploy')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--force" "--precompilejsp" "--verify" "--createtables" "--dropandcreatetables" "--uniquetablenames" "--enabled" "--generatermistubs" "--availabilityenabled" "--asyncreplication" "--keepreposdir" "--keepfailedstubs" "--isredeploy" "--logReportedErrors" "--keepstate" "--upload" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--name" "--contextroot" "--virtualservers" "--libraries" "--force" "--precompilejsp" "--verify" "--retrieve" "--dbvendorname" "--createtables" "--dropandcreatetables" "--uniquetablenames" "--deploymentplan" "--altdd" "--runtimealtdd" "--enabled" "--generatermistubs" "--availabilityenabled" "--asyncreplication" "--target" "--keepreposdir" "--keepfailedstubs" "--isredeploy" "--logReportedErrors" "--description" "--properties" "--property" "--type" "--keepstate" "--lbenabled" "--deploymentorder" "--upload" 
                    ;;
                'deploydir')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--force" "--precompilejsp" "--verify" "--createtables" "--dropandcreatetables" "--uniquetablenames" "--enabled" "--generatermistubs" "--availabilityenabled" "--asyncreplication" "--keepreposdir" "--keepfailedstubs" "--isredeploy" "--logReportedErrors" "--keepstate" "--upload" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--name" "--contextroot" "--virtualservers" "--libraries" "--force" "--precompilejsp" "--verify" "--retrieve" "--dbvendorname" "--createtables" "--dropandcreatetables" "--uniquetablenames" "--deploymentplan" "--altdd" "--runtimealtdd" "--enabled" "--generatermistubs" "--availabilityenabled" "--asyncreplication" "--target" "--keepreposdir" "--keepfailedstubs" "--isredeploy" "--logReportedErrors" "--description" "--properties" "--property" "--type" "--keepstate" "--lbenabled" "--deploymentorder" "--upload" 
                    ;;
                'disable')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--isundeploy" "--keepreposdir" "--isredeploy" "--droptables" "--cascade" "--keepstate" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--isundeploy" "--target" "--keepreposdir" "--isredeploy" "--droptables" "--cascade" "--properties" "--keepstate" 
                    ;;
                'disable-http-lb-application')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--name" "--timeout" 
                    ;;
                'disable-http-lb-server')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--timeout" 
                    ;;
                'disable-monitoring')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" "--modules" 
                    ;;
                'disable-secure-admin')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    ;;
                'disable-secure-admin-internal-user')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    ;;
                'disable-secure-admin-principal')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--alias" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--alias" 
                    ;;
                'enable')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    ;;
                'enable-http-lb-application')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--name" 
                    ;;
                'enable-http-lb-server')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    ;;
                'enable-monitoring')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--mbean" "--dtrace" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" "--pid" "--options" "--modules" "--mbean" "--dtrace" 
                    ;;
                'enable-secure-admin')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--adminalias" "--instancealias" 
                    ;;
                'enable-secure-admin-internal-user')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--passwordAlias" 
                    ;;
                'enable-secure-admin-principal')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--alias" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--alias" 
                    ;;
                'export')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    ;;
                'export-http-lb-config')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--retrievefile" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--lbtargets" "--config" "--lbname" "--retrievefile" "--property" 
                    ;;
                'export-sync-bundle')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--retrieve" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" "--retrieve" 
                    ;;
                'flush-connection-pool')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--appname" "--modulename" 
                    ;;
                'flush-jmsdest')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--destType -T" "--target" 
                    ;;
                'freeze-transaction-service')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    ;;
                'generate-domain-schema')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--showSubclasses" "--showDeprecated" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--format" "--showSubclasses" "--showDeprecated" 
                    ;;
                'generate-jvm-report')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" "--type" 
                    ;;
                'get')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--monitor" "-m" "--aggregateDataOnly" "-c" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--monitor -m" "--aggregateDataOnly -c" 
                    ;;
                'get-active-module-config')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--all" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" "--all" 
                    ;;
                'get-client-stubs')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--appname" 
                    ;;
                'get-health')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    ;;
                'help')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    ;;
                'import-sync-bundle')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--instance" "--node --nodeagent" "--nodedir --agentdir" 
                    ;;
                'install-node')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--sshuser" "--sshport" "--sshkeyfile" "--archive" "--installdir" "--create" "--save" "--force" 
                    ;;
                'install-node-dcom')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--windowsuser -w" "--windowsdomain -d" "--archive" "--installdir" "--create" "--save" "--force" 
                    ;;
                'install-node-ssh')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--sshuser" "--sshport" "--sshkeyfile" "--archive" "--installdir" "--create" "--save" "--force" 
                    ;;
                'jms-ping')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    ;;
                'list')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--MoniTor" "--Mon" "-m" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--MoniTor --Mon -m" 
                    ;;
                'list-admin-objects')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    ;;
                'list-application-refs')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--long" "-l" "--terse" "-t" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--long -l" "--terse -t" 
                    ;;
                'list-applications')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--long" "-l" "--terse" "-t" "--subcomponents" "--resources" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--type" "--long -l" "--terse -t" "--subcomponents" "--resources" 
                    ;;
                'list-audit-modules')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    ;;
                'list-auth-realms')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    ;;
                'list-backups')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--long --verbose -l" "--backupConfig" "--backupdir" "--domaindir" 
                    ;;
                'list-batch-job-executions')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--terse" "-t" "--header" "-h" "--long" "-l" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--executionid -x" "--terse -t" "--output -o" "--header -h" "--target" "--long -l" 
                    ;;
                'list-batch-jobs')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--terse" "-t" "--header" "-h" "--long" "-l" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--terse -t" "--output -o" "--header -h" "--target" "--long -l" 
                    ;;
                'list-batch-job-steps')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--terse" "-t" "--header" "-h" "--long" "-l" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--terse -t" "--output -o" "--header -h" "--target" "--long -l" 
                    ;;
                'list-batch-runtime-configuration')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--terse" "-t" "--header" "-h" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--terse -t" "--output -o" "--header -h" "--target" 
                    ;;
                'list-clusters')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    ;;
                'list-commands')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--localonly" "--remoteonly" 
                    ;;
                'list-components')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--long" "-l" "--terse" "-t" "--subcomponents" "--resources" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--type" "--long -l" "--terse -t" "--subcomponents" "--resources" 
                    ;;
                'list-configs')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    ;;
                'list-connector-connection-pools')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    ;;
                'list-connector-resources')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    ;;
                'list-connector-security-maps')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--long" "--verbose" "-l" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--securitymap" "--long --verbose -l" "--target --targetName" 
                    ;;
                'list-connector-work-security-maps')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--securitymap" 
                    ;;
                'list-containers')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    ;;
                'list-context-services')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    ;;
                'list-custom-resources')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    ;;
                'list-domains')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--long -l" "--header -h" "--domaindir" 
                    ;;
                'list-file-groups')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--authrealmname" "--name" 
                    ;;
                'list-file-users')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--authrealmname" 
                    ;;
                'list-http-lb-configs')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    ;;
                'list-http-lbs')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--long" "-l" "--header" "-h" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--output -o" "--long -l" "--header -h" 
                    ;;
                'list-http-listeners')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--long" "-l" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--long -l" 
                    ;;
                'list-iiop-listeners')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    ;;
                'list-instances')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--long" "-l" "--standaloneonly" "--nostatus" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--long -l" "--timeoutmsec" "--standaloneonly" "--nostatus" 
                    ;;
                'list-jacc-providers')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    ;;
                'list-javamail-resources')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    ;;
                'list-jdbc-connection-pools')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    ;;
                'list-jdbc-resources')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    ;;
                'list-jmsdest')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--destType" "--property" 
                    ;;
                'list-jms-hosts')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    ;;
                'list-jms-resources')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--resType" 
                    ;;
                'list-jndi-entries')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--context" 
                    ;;
                'list-jndi-resources')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    ;;
                'list-jobs')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    ;;
                'list-jvm-options')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--profiler" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" "--profiler" 
                    ;;
                'list-libraries')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--type" 
                    ;;
                'list-lifecycle-modules')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--terse" "-t" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--terse -t" 
                    ;;
                'list-log-attributes')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    ;;
                'list-loggers')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    ;;
                'list-log-levels')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    ;;
                'list-managed-executor-services')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    ;;
                'list-managed-scheduled-executor-services')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    ;;
                'list-managed-thread-factories')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    ;;
                'list-message-security-providers')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--layer" 
                    ;;
                'list-modules')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    ;;
                'list-network-listeners')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    ;;
                'list-nodes')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--long" "-l" "--terse" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--long -l" "--terse" 
                    ;;
                'list-nodes-config')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--long" "-l" "--terse" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--long -l" "--terse" 
                    ;;
                'list-nodes-dcom')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--long" "-l" "--terse" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--long -l" "--terse" 
                    ;;
                'list-nodes-ssh')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--long" "-l" "--terse" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--long -l" "--terse" 
                    ;;
                'list-password-aliases')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    ;;
                'list-persistence-types')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--type" 
                    ;;
                'list-protocol-filters')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    ;;
                'list-protocol-finders')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    ;;
                'list-protocols')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    ;;
                'list-resource-adapter-configs')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--long" "--verbose" "-l" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--raname" "--long --verbose -l" 
                    ;;
                'list-resource-refs')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    ;;
                'list-secure-admin-internal-users')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--long" "-l" "--header" "-h" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--output -o" "--long -l" "--header -h" 
                    ;;
                'list-secure-admin-principals')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--long" "-l" "--header" "-h" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--output -o" "--long -l" "--header -h" 
                    ;;
                'list-sub-components')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--resources" "--terse" "-t" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--appname" "--type" "--resources" "--terse -t" 
                    ;;
                'list-supported-cipher-suites')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    ;;
                'list-system-properties')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    ;;
                'list-threadpools')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    ;;
                'list-timers')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    ;;
                'list-transports')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    ;;
                'list-virtual-servers')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    ;;
                'list-web-context-param')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--name" 
                    ;;
                'list-web-env-entry')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--name" 
                    ;;
                'login')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    ;;
                'migrate-timers')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target --destination" 
                    ;;
                'monitor')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--interval" "--type" "--filter" "--fileName" 
                    ;;
                'multimode')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--printprompt" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--file -f" "--printprompt" "--encoding" 
                    ;;
                'osgi')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--session" "--session-id" "--instance" 
                    ;;
                'osgi-shell')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--printprompt" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--instance" "--file -f" "--printprompt" "--encoding" 
                    ;;
                'ping-connection-pool')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--appname" "--modulename" "--target --targetName" 
                    ;;
                'ping-node-dcom')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--validate" "--full" "-v" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--validate --full -v" 
                    ;;
                'ping-node-ssh')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--validate" "--full" "-v" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--validate --full -v" 
                    ;;
                'recover-transactions')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target --destination" "--transactionlogdir" 
                    ;;
                'redeploy')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--force" "--precompilejsp" "--verify" "--createtables" "--dropandcreatetables" "--uniquetablenames" "--enabled" "--generatermistubs" "--availabilityenabled" "--asyncreplication" "--keepreposdir" "--keepfailedstubs" "--isredeploy" "--logReportedErrors" "--keepstate" "--upload" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--name" "--contextroot" "--virtualservers" "--libraries" "--force" "--precompilejsp" "--verify" "--retrieve" "--dbvendorname" "--createtables" "--dropandcreatetables" "--uniquetablenames" "--deploymentplan" "--altdd" "--runtimealtdd" "--enabled" "--generatermistubs" "--availabilityenabled" "--asyncreplication" "--target" "--keepreposdir" "--keepfailedstubs" "--isredeploy" "--logReportedErrors" "--description" "--properties" "--property" "--type" "--keepstate" "--lbenabled" "--deploymentorder" "--upload" 
                    ;;
                'remove-library')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--type" 
                    ;;
                'restart-domain')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--debug" "--force" "--kill" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--debug" "--force" "--kill" "--domaindir" 
                    ;;
                'restart-instance')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--debug" 
                    ;;
                'restart-local-instance')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--debug" "--force" "--kill" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--debug" "--force" "--kill" "--nodedir --agentdir" "--node --nodeagent" 
                    ;;
                'restore-domain')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--filename" "--force" "--description" "--long --verbose -l" "--backupConfig" "--backupdir" "--domaindir" 
                    ;;
                'rollback-transaction')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" "--transaction_id" 
                    ;;
                'rotate-log')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    ;;
                'set')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    ;;
                'set-batch-runtime-configuration')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" "--dataSourceLookupName -d" "--executorServiceLookupName -x" 
                    ;;
                'set-log-attributes')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    ;;
                'set-log-file-format')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    ;;
                'set-log-levels')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    ;;
                'setup-local-dcom')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--verbose -v" "--force -f" 
                    ;;
                'setup-ssh')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--sshuser" "--sshport" "--sshkeyfile" "--sshpublickeyfile" "--generatekey" 
                    ;;
                'set-web-context-param')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--ignoreDescriptorItem" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--name" "--value" "--description" "--ignoreDescriptorItem" 
                    ;;
                'set-web-env-entry')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--ignoreDescriptorItem" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--name" "--value" "--type" "--description" "--ignoreDescriptorItem" 
                    ;;
                'show-component-status')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    ;;
                'start-cluster')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--verbose" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--verbose" 
                    ;;
                'start-database')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--dbhome" "--jvmoptions" "--dbhost" "--dbport" 
                    ;;
                'start-domain')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--verbose -v" "--upgrade" "--watchdog -w" "--debug -d" "--dry-run -n" "--drop-interrupted-commands" "--domaindir" 
                    ;;
                'start-instance')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--debug" "--terse" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--sync" "--debug" "--terse" "--setenv" 
                    ;;
                'start-local-instance')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--verbose -v" "--watchdog -w" "--debug -d" "--dry-run -n" "--sync" "--nodedir --agentdir" "--node --nodeagent" 
                    ;;
                'stop-cluster')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--kill" "--verbose" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--kill" "--verbose" 
                    ;;
                'stop-database')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--dbuser" "--dbhost" "--dbport" 
                    ;;
                'stop-domain')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--force" "--kill" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--force" "--kill" "--domaindir" 
                    ;;
                'stop-instance')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--force" "--kill" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--force" "--kill" 
                    ;;
                'stop-local-instance')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--force" "--kill" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--force" "--kill" "--nodedir --agentdir" "--node --nodeagent" 
                    ;;
                'undeploy')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--keepreposdir" "--isredeploy" "--droptables" "--cascade" "--keepstate" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" "--keepreposdir" "--isredeploy" "--droptables" "--cascade" "--properties" "--keepstate" 
                    ;;
                'unfreeze-transaction-service')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    ;;
                'uninstall-node')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--sshuser" "--sshport" "--sshkeyfile" "--installdir" "--force" 
                    ;;
                'uninstall-node-dcom')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--windowsuser -w" "--windowsdomain -d" "--installdir" "--force" 
                    ;;
                'uninstall-node-ssh')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--sshuser" "--sshport" "--sshkeyfile" "--installdir" "--force" 
                    ;;
                'unset')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    ;;
                'unset-web-context-param')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--name" 
                    ;;
                'unset-web-env-entry')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--name" 
                    ;;
                'update-connector-security-map')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" "--poolname" "--addprincipals" "--addusergroups" "--removeprincipals" "--removeusergroups" "--mappedusername" "--mappedpassword" 
                    ;;
                'update-connector-work-security-map')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--raname" "--addprincipals" "--addgroups" "--removeprincipals" "--removegroups" 
                    ;;
                'update-file-user')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--groups" "--userpassword" "--authrealmname" "--target" 
                    ;;
                'update-node-config')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--nodehost" "--installdir" "--nodedir" 
                    ;;
                'update-node-dcom')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--force" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--windowsuser -w" "--windowspassword" "--windowsdomain -d" "--nodehost" "--installdir" "--nodedir" "--force" 
                    ;;
                'update-node-ssh')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--force" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--sshport" "--sshuser" "--sshkeyfile" "--sshpassword" "--sshkeypassphrase" "--nodehost" "--installdir" "--nodedir" "--force" 
                    ;;
                'update-password-alias')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--aliaspassword" 
                    ;;
                'uptime')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--milliseconds" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--milliseconds" 
                    ;;
                'validate-dcom')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--verbose" "-v" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--windowsuser -w" "--windowspassword" "--windowsdomain -d" "--remotetestdir" "--verbose -v" 
                    ;;
                'validate-multicast')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--multicastport" "--multicastaddress" "--bindaddress" "--sendperiod" "--timeout" "--timetolive" "--verbose -v" 
                    ;;
                'verify-domain-xml')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--domaindir" 
                    ;;
                'version')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--verbose -v" "--local" "--terse" 
                    ;;
            esac
            if $commandisdefined ; then 
                break 
            fi
        fi 
    done

    if ! $commandisdefined ; then
            case "$cur" in
                "ahttplc") COMPREPLY=( "apply-http-lb-changes" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "alb") COMPREPLY=( "add-library" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "ar") COMPREPLY=( "add-resources" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "bd") COMPREPLY=( "backup-domain" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "cam") COMPREPLY=( "create-audit-module" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "cao") COMPREPLY=( "create-admin-object" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "cap") COMPREPLY=( "change-admin-password" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "caref") COMPREPLY=( "create-application-ref" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "cc") COMPREPLY=( "create-cluster" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "cccp") COMPREPLY=( "create-connector-connection-pool" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "cconf") COMPREPLY=( "copy-config" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "cconr") COMPREPLY=( "create-connector-resource" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "cconres") COMPREPLY=( "create-connector-resource" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "ccr") COMPREPLY=( "create-custom-resource" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "ccres") COMPREPLY=( "create-custom-resource" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "ccs") COMPREPLY=( "create-context-service" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "ccsm") COMPREPLY=( "create-connector-security-map" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "ccwsm") COMPREPLY=( "create-connector-work-security-map" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "cd") COMPREPLY=( "create-domain" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "cfu") COMPREPLY=( "create-file-user" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "chttp") COMPREPLY=( "create-http" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "chttphc") COMPREPLY=( "create-http-health-checker" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "chttpl") COMPREPLY=( "create-http-listener" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "chttplb") COMPREPLY=( "create-http-lb" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "chttplc") COMPREPLY=( "create-http-lb-config" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "chttplr") COMPREPLY=( "create-http-lb-ref" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "chttpr") COMPREPLY=( "create-http-redirect" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "ci") COMPREPLY=( "create-instance" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "cil") COMPREPLY=( "create-iiop-listener" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "cj") COMPREPLY=( "create-jmsdest" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "cjdbccp") COMPREPLY=( "create-jdbc-connection-pool" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "cjdbcr") COMPREPLY=( "create-jdbc-resource" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "cjmr") COMPREPLY=( "create-javamail-resource" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "cjmsc") COMPREPLY=( "configure-jms-cluster" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "cjmsh") COMPREPLY=( "create-jms-host" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "cjmsr") COMPREPLY=( "create-jms-resource" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "cjndir") COMPREPLY=( "create-jndi-resource" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "cjo") COMPREPLY=( "create-jvm-options" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "cjp") COMPREPLY=( "create-jacc-provider" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "clf") COMPREPLY=( "collect-log-files" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "clfa") COMPREPLY=( "configure-ldap-for-admin" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "cli") COMPREPLY=( "create-local-instance" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "clm") COMPREPLY=( "create-lifecycle-module" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "clw") COMPREPLY=( "configure-lb-weight" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "cmb") COMPREPLY=( "change-master-broker" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "cmc") COMPREPLY=( "create-module-config" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "cmes") COMPREPLY=( "create-managed-executor-service" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "cmj") COMPREPLY=( "configure-managed-jobs" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "cmp") COMPREPLY=( "change-master-password" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "cmses") COMPREPLY=( "create-managed-scheduled-executor-service" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "cmsp") COMPREPLY=( "create-message-security-provider" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "cmtf") COMPREPLY=( "create-managed-thread-factory" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "cnc") COMPREPLY=( "create-node-config" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "cnd") COMPREPLY=( "create-node-dcom" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "cnl") COMPREPLY=( "create-network-listener" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "cns") COMPREPLY=( "create-node-ssh" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "cpa") COMPREPLY=( "create-password-alias" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "crac") COMPREPLY=( "create-resource-adapter-config" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "crlm") COMPREPLY=( "create-auth-realm" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "crr") COMPREPLY=( "create-resource-ref" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "cs") COMPREPLY=( "create-service" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "csp") COMPREPLY=( "create-system-properties" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "cssl") COMPREPLY=( "create-ssl" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "ct") COMPREPLY=( "create-transport" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "ctp") COMPREPLY=( "create-threadpool" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "cvs") COMPREPLY=( "create-virtual-server" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "dam") COMPREPLY=( "delete-audit-module" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "dao") COMPREPLY=( "delete-admin-object" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "daref") COMPREPLY=( "delete-application-ref" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "dc") COMPREPLY=( "delete-cluster" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "dccp") COMPREPLY=( "delete-connector-connection-pool" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "dconf") COMPREPLY=( "delete-config" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "dconr") COMPREPLY=( "delete-connector-resource" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "dconres") COMPREPLY=( "delete-connector-resource" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "dcr") COMPREPLY=( "delete-custom-resource" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "dcres") COMPREPLY=( "delete-custom-resource" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "dcs") COMPREPLY=( "delete-context-service" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "dcsm") COMPREPLY=( "delete-connector-security-map" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "dcwsm") COMPREPLY=( "delete-connector-work-security-map" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "dd") COMPREPLY=( "delete-domain" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "dfu") COMPREPLY=( "delete-file-user" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "dhttp") COMPREPLY=( "delete-http" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "dhttphc") COMPREPLY=( "delete-http-health-checker" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "dhttpl") COMPREPLY=( "delete-http-listener" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "dhttpla") COMPREPLY=( "disable-http-lb-application" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "dhttplb") COMPREPLY=( "delete-http-lb" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "dhttplc") COMPREPLY=( "delete-http-lb-config" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "dhttplr") COMPREPLY=( "delete-http-lb-ref" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "dhttpls") COMPREPLY=( "disable-http-lb-server" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "dhttpr") COMPREPLY=( "delete-http-redirect" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "dil") COMPREPLY=( "delete-iiop-listener" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "dinst") COMPREPLY=( "delete-instance" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "dj") COMPREPLY=( "delete-jmsdest" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "djdbccp") COMPREPLY=( "delete-jdbc-connection-pool" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "djdbcr") COMPREPLY=( "delete-jdbc-resource" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "djmsh") COMPREPLY=( "delete-jms-host" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "djmsr") COMPREPLY=( "delete-jms-resource" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "djndir") COMPREPLY=( "delete-jndi-resource" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "djo") COMPREPLY=( "delete-jvm-options" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "djp") COMPREPLY=( "delete-jacc-provider" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "djr") COMPREPLY=( "delete-javamail-resource" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "dli") COMPREPLY=( "delete-local-instance" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "dll") COMPREPLY=( "delete-log-levels" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "dlm") COMPREPLY=( "delete-lifecycle-module" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "dm") COMPREPLY=( "disable-monitoring" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "dmc") COMPREPLY=( "delete-module-config" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "dmes") COMPREPLY=( "delete-managed-executor-service" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "dmses") COMPREPLY=( "delete-managed-scheduled-executor-service" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "dmsp") COMPREPLY=( "delete-message-security-provider" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "dmtf") COMPREPLY=( "delete-managed-thread-factory" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "dnc") COMPREPLY=( "delete-node-config" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "dnd") COMPREPLY=( "delete-node-dcom" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "dnl") COMPREPLY=( "delete-network-listener" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "dns") COMPREPLY=( "delete-node-ssh" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "dpa") COMPREPLY=( "delete-password-alias" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "dpl") COMPREPLY=( "deploy" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "dpldr") COMPREPLY=( "deploydir" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "drac") COMPREPLY=( "delete-resource-adapter-config" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "drlm") COMPREPLY=( "delete-auth-realm" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "drr") COMPREPLY=( "delete-resource-ref" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "ds") COMPREPLY=( "delete-ssl" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "dsa") COMPREPLY=( "disable-secure-admin" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "dsaiu") COMPREPLY=( "disable-secure-admin-internal-user" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "dsap") COMPREPLY=( "disable-secure-admin-principal" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "dsbl") COMPREPLY=( "disable" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "dsp") COMPREPLY=( "delete-system-property" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "dt") COMPREPLY=( "delete-transport" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "dtp") COMPREPLY=( "delete-threadpool" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "dvs") COMPREPLY=( "delete-virtual-server" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "ehttpla") COMPREPLY=( "enable-http-lb-application" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "ehttplc") COMPREPLY=( "export-http-lb-config" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "ehttpls") COMPREPLY=( "enable-http-lb-server" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "em") COMPREPLY=( "enable-monitoring" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "esa") COMPREPLY=( "enable-secure-admin" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "esaiu") COMPREPLY=( "enable-secure-admin-internal-user" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "esap") COMPREPLY=( "enable-secure-admin-principal" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "esb") COMPREPLY=( "export-sync-bundle" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "fcp") COMPREPLY=( "flush-connection-pool" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "fj") COMPREPLY=( "flush-jmsdest" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "fts") COMPREPLY=( "freeze-transaction-service" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "gamc") COMPREPLY=( "get-active-module-config" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "gcs") COMPREPLY=( "get-client-stubs" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "gds") COMPREPLY=( "generate-domain-schema" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "gh") COMPREPLY=( "get-health" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "gjr") COMPREPLY=( "generate-jvm-report" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "gt") COMPREPLY=( "get" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "hlp") COMPREPLY=( "help" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "ind") COMPREPLY=( "install-node-dcom" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "isb") COMPREPLY=( "import-sync-bundle" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "jmsp") COMPREPLY=( "jms-ping" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "la") COMPREPLY=( "list-applications" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "lam") COMPREPLY=( "list-audit-modules" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "lao") COMPREPLY=( "list-admin-objects" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "laref") COMPREPLY=( "list-application-refs" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "lb") COMPREPLY=( "list-backups" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "lbj") COMPREPLY=( "list-batch-jobs" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "lbje") COMPREPLY=( "list-batch-job-executions" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "lbjs") COMPREPLY=( "list-batch-job-steps" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "lbrc") COMPREPLY=( "list-batch-runtime-configuration" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "lc") COMPREPLY=( "list-clusters" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "lccp") COMPREPLY=( "list-connector-connection-pools" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "lcmd") COMPREPLY=( "list-commands" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "lcmp") COMPREPLY=( "list-components" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "lconf") COMPREPLY=( "list-configs" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "lcs") COMPREPLY=( "list-context-services" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "lcsm") COMPREPLY=( "list-connector-security-maps" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "lcwsm") COMPREPLY=( "list-connector-work-security-maps" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "ld") COMPREPLY=( "list-domains" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "lfg") COMPREPLY=( "list-file-groups" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "lfu") COMPREPLY=( "list-file-users" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "lgn") COMPREPLY=( "login" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "lhttplb") COMPREPLY=( "list-http-lbs" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "lhttplc") COMPREPLY=( "list-http-lb-configs" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "lhttplist") COMPREPLY=( "list-http-listeners" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "lil") COMPREPLY=( "list-iiop-listeners" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "linst") COMPREPLY=( "list-instances" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "ljdbccp") COMPREPLY=( "list-jdbc-connection-pools" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "ljdbcr") COMPREPLY=( "list-jdbc-resources" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "ljmr") COMPREPLY=( "list-javamail-resources" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "ljmsh") COMPREPLY=( "list-jms-hosts" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "ljmsr") COMPREPLY=( "list-jms-resources" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "ljndie") COMPREPLY=( "list-jndi-entries" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "ljndir") COMPREPLY=( "list-jndi-resources" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "ljo") COMPREPLY=( "list-jvm-options" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "ljp") COMPREPLY=( "list-jacc-providers" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "lla") COMPREPLY=( "list-log-attributes" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "llb") COMPREPLY=( "list-libraries" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "llg") COMPREPLY=( "list-loggers" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "lll") COMPREPLY=( "list-log-levels" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "llm") COMPREPLY=( "list-lifecycle-modules" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "llog") COMPREPLY=( "list-loggers" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "lm") COMPREPLY=( "list-modules" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "lmes") COMPREPLY=( "list-managed-executor-services" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "lmses") COMPREPLY=( "list-managed-scheduled-executor-services" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "lmsp") COMPREPLY=( "list-message-security-providers" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "lmtf") COMPREPLY=( "list-managed-thread-factories" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "ln") COMPREPLY=( "list-nodes" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "lnc") COMPREPLY=( "list-nodes-config" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "lnd") COMPREPLY=( "list-nodes-dcom" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "lnl") COMPREPLY=( "list-network-listeners" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "lns") COMPREPLY=( "list-nodes-ssh" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "lp") COMPREPLY=( "list-protocols" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "lpa") COMPREPLY=( "list-password-aliases" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "lpt") COMPREPLY=( "list-persistence-types" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "lrac") COMPREPLY=( "list-resource-adapter-configs" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "lrlm") COMPREPLY=( "list-auth-realms" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "lrr") COMPREPLY=( "list-resource-refs" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "lsaiu") COMPREPLY=( "list-secure-admin-internal-users" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "lsap") COMPREPLY=( "list-secure-admin-principals" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "lsc") COMPREPLY=( "list-sub-components" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "lscs") COMPREPLY=( "list-supported-cipher-suites" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "lsp") COMPREPLY=( "list-system-properties" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "lst") COMPREPLY=( "list" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "ltp") COMPREPLY=( "list-threadpools" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "lvs") COMPREPLY=( "list-virtual-servers" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "lwcp") COMPREPLY=( "list-web-context-param" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "lwee") COMPREPLY=( "list-web-env-entry" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "mltmd") COMPREPLY=( "multimode" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "mntr") COMPREPLY=( "monitor" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "mt") COMPREPLY=( "migrate-timers" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "nbl") COMPREPLY=( "enable" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "nst") COMPREPLY=( "unset" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "pcp") COMPREPLY=( "ping-connection-pool" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "pnd") COMPREPLY=( "ping-node-dcom" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "pns") COMPREPLY=( "ping-node-ssh" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "ptm") COMPREPLY=( "uptime" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "rbt") COMPREPLY=( "rollback-transaction" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "rdpl") COMPREPLY=( "redeploy" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "rl") COMPREPLY=( "rotate-log" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "rlb") COMPREPLY=( "remove-library" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "rlib") COMPREPLY=( "remove-library" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "rsd") COMPREPLY=( "restart-domain" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "rsi") COMPREPLY=( "restart-instance" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "rsli") COMPREPLY=( "restart-local-instance" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "rstd") COMPREPLY=( "restore-domain" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "rt") COMPREPLY=( "recover-transactions" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "sbrc") COMPREPLY=( "set-batch-runtime-configuration" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "sc") COMPREPLY=( "start-cluster" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "scs") COMPREPLY=( "show-component-status" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "sd") COMPREPLY=( "start-domain" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "sdb") COMPREPLY=( "start-database" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "sg") COMPREPLY=( "osgi" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "si") COMPREPLY=( "start-instance" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "sla") COMPREPLY=( "set-log-attributes" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "sld") COMPREPLY=( "setup-local-dcom" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "slff") COMPREPLY=( "set-log-file-format" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "sli") COMPREPLY=( "start-local-instance" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "sll") COMPREPLY=( "set-log-levels" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "ss") COMPREPLY=( "setup-ssh" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "stpc") COMPREPLY=( "stop-cluster" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "stpd") COMPREPLY=( "stop-domain" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "stpdb") COMPREPLY=( "stop-database" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "stpi") COMPREPLY=( "stop-instance" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "stpli") COMPREPLY=( "stop-local-instance" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "swcp") COMPREPLY=( "set-web-context-param" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "swee") COMPREPLY=( "set-web-env-entry" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "ttch") COMPREPLY=( "attach" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "ucsm") COMPREPLY=( "update-connector-security-map" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "ucwsm") COMPREPLY=( "update-connector-work-security-map" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "udpl") COMPREPLY=( "undeploy" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "ufu") COMPREPLY=( "update-file-user" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "unc") COMPREPLY=( "update-node-config" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "undpl") COMPREPLY=( "undeploy" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "unn") COMPREPLY=( "uninstall-node" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "upa") COMPREPLY=( "update-password-alias" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "uts") COMPREPLY=( "unfreeze-transaction-service" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "uwcp") COMPREPLY=( "unset-web-context-param" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "uwee") COMPREPLY=( "unset-web-env-entry" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "vd") COMPREPLY=( "validate-dcom" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "vdx") COMPREPLY=( "verify-domain-xml" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "vm") COMPREPLY=( "validate-multicast" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "vrsn") COMPREPLY=( "version" )
                    COMPPOSIB=();
                    return 0;
                    ;;
                "xprt") COMPREPLY=( "export" )
                    COMPPOSIB=();
                    return 0;
                    ;;
            esac
         
        #General attributes of asadmin
        _nclnac_addNonexistMulti "--host -H" "--port -p" "--user -u" "--passwordfile -W" "--terse -t" "--secure -s" "--echo -e" "--interactive -I"
        #Add all commands 
        COMPPOSIB=( ${COMPPOSIB[@]} add-library add-resources apply-http-lb-changes attach backup-domain change-admin-password change-master-broker change-master-password collect-log-files configure-jms-cluster configure-lb-weight configure-ldap-for-admin configure-managed-jobs copy-config create-admin-object create-application-ref create-audit-module create-auth-realm create-cluster create-connector-connection-pool create-connector-resource create-connector-security-map create-connector-work-security-map create-context-service create-custom-resource create-domain create-file-user create-http create-http-health-checker create-http-lb create-http-lb-config create-http-lb-ref create-http-listener create-http-redirect create-iiop-listener create-instance create-jacc-provider create-javamail-resource create-jdbc-connection-pool create-jdbc-resource create-jmsdest create-jms-host create-jms-resource create-jndi-resource create-jvm-options create-lifecycle-module create-local-instance create-managed-executor-service create-managed-scheduled-executor-service create-managed-thread-factory create-message-security-provider create-module-config create-network-listener create-node-config create-node-dcom create-node-ssh create-password-alias create-profiler create-protocol create-protocol-filter create-protocol-finder create-resource-adapter-config create-resource-ref create-service create-ssl create-system-properties create-threadpool create-transport create-virtual-server delete-admin-object delete-application-ref delete-audit-module delete-auth-realm delete-cluster delete-config delete-connector-connection-pool delete-connector-resource delete-connector-security-map delete-connector-work-security-map delete-context-service delete-custom-resource delete-domain delete-file-user delete-http delete-http-health-checker delete-http-lb delete-http-lb-config delete-http-lb-ref delete-http-listener delete-http-redirect delete-iiop-listener delete-instance delete-jacc-provider delete-javamail-resource delete-jdbc-connection-pool delete-jdbc-resource delete-jmsdest delete-jms-host delete-jms-resource delete-jndi-resource delete-jvm-options delete-lifecycle-module delete-local-instance delete-log-levels delete-managed-executor-service delete-managed-scheduled-executor-service delete-managed-thread-factory delete-message-security-provider delete-module-config delete-network-listener delete-node-config delete-node-dcom delete-node-ssh delete-password-alias delete-profiler delete-protocol delete-protocol-filter delete-protocol-finder delete-resource-adapter-config delete-resource-ref delete-ssl delete-system-property delete-threadpool delete-transport delete-virtual-server deploy deploydir disable disable-http-lb-application disable-http-lb-server disable-monitoring disable-secure-admin disable-secure-admin-internal-user disable-secure-admin-principal enable enable-http-lb-application enable-http-lb-server enable-monitoring enable-secure-admin enable-secure-admin-internal-user enable-secure-admin-principal export export-http-lb-config export-sync-bundle flush-connection-pool flush-jmsdest freeze-transaction-service generate-domain-schema generate-jvm-report get get-active-module-config get-client-stubs get-health help import-sync-bundle install-node install-node-dcom install-node-ssh jms-ping list list-admin-objects list-application-refs list-applications list-audit-modules list-auth-realms list-backups list-batch-job-executions list-batch-jobs list-batch-job-steps list-batch-runtime-configuration list-clusters list-commands list-components list-configs list-connector-connection-pools list-connector-resources list-connector-security-maps list-connector-work-security-maps list-containers list-context-services list-custom-resources list-domains list-file-groups list-file-users list-http-lb-configs list-http-lbs list-http-listeners list-iiop-listeners list-instances list-jacc-providers list-javamail-resources list-jdbc-connection-pools list-jdbc-resources list-jmsdest list-jms-hosts list-jms-resources list-jndi-entries list-jndi-resources list-jobs list-jvm-options list-libraries list-lifecycle-modules list-log-attributes list-loggers list-log-levels list-managed-executor-services list-managed-scheduled-executor-services list-managed-thread-factories list-message-security-providers list-modules list-network-listeners list-nodes list-nodes-config list-nodes-dcom list-nodes-ssh list-password-aliases list-persistence-types list-protocol-filters list-protocol-finders list-protocols list-resource-adapter-configs list-resource-refs list-secure-admin-internal-users list-secure-admin-principals list-sub-components list-supported-cipher-suites list-system-properties list-threadpools list-timers list-transports list-virtual-servers list-web-context-param list-web-env-entry login migrate-timers monitor multimode osgi osgi-shell ping-connection-pool ping-node-dcom ping-node-ssh recover-transactions redeploy remove-library restart-domain restart-instance restart-local-instance restore-domain rollback-transaction rotate-log set set-batch-runtime-configuration set-log-attributes set-log-file-format set-log-levels setup-local-dcom setup-ssh set-web-context-param set-web-env-entry show-component-status start-cluster start-database start-domain start-instance start-local-instance stop-cluster stop-database stop-domain stop-instance stop-local-instance undeploy unfreeze-transaction-service uninstall-node uninstall-node-dcom uninstall-node-ssh unset unset-web-context-param unset-web-env-entry update-connector-security-map update-connector-work-security-map update-file-user update-node-config update-node-dcom update-node-ssh update-password-alias uptime validate-dcom validate-multicast verify-domain-xml version )
    fi
    COMPREPLY=( $(compgen -W "${COMPPOSIB[*]}" -- ${cur}) )
    COMPPOSIB=() #Clean it
    return 0
}

#Define completion for
complete -o default -F _nclnac_asadmin asadmin