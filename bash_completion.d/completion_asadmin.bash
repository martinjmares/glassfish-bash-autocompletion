# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
# 

#
# *******************************************************************
# * Bash autocompletion for GlassFish 4 asadmin utility             *
# * ===================================================             *
# *                                                                 *
# * Version: 1.0-Beta                                               *
# * For: asadmin utility of GlassFish 4                             *
# *                                                                 *
# * INSTALL:                                                        *
# * Source this file into your TTY. Then use <TAB> and <TAB><TAB>   *
# * while compose your asadmin command line string.                 *
# *******************************************************************
#

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

_nclnac_extractBasicCallParams () {
    local cmpw addarg rslt
    rslt="${COMP_WORDS[0]}"
    addarg=FALSE
    for cmpw in "${COMP_WORDS[@]:1}" ; do
        if $addarg ; then
            rslt="$rslt $cmpw"
            addarg=FALSE
            continue
        fi
        case "$cmpw" in
            --host|-H|--port|-p|--user|-u|--passwordfile|-W)
                rslt="$rslt $cmpw"
                addarg=TRUE
                ;;
            --host=*|-H=*|--port=*|-p=*|--user=*|-u=*|--passwordfile=*|-W=*)
                rslt="$rslt $cmpw"
                ;;
        esac
    done
    echo "$rslt"
}

_nclnac_locateTempDir () {
    local result
    if [[ -d "$TMPDIR" ]] && [[ -w "$TMPDIR" ]] ; then
        echo "$TMPDIR"
        return 0
    fi
    if [[ -d "/tmp" ]] && [[ -w "/tmp" ]] ; then
        echo "/tmp"
        return 0
    fi
    result="`dirname \"$0\"`"
    if [[ -d "$result" ]] && [[ -w "$result" ]] ; then
        echo "$result"
        return 0
    fi
    return 1
}

_nclnac_cliList () {
    local old_IFS cmdname cmdrslt cachefile elapsed alternatives
    cmdname="$(_nclnac_extractBasicCallParams) --terse $1 2>/dev/null"

    #search in cache
    cachefile="$(_nclnac_locateTempDir)/`echo "$cmdname" | xargs -n1 | sort -u | md5`.ascompcache"
    if [[ -e "$cachefile" ]] ; then
        let elapsed=`date +%s`-`stat -f %c "$cachefile"`
        if (( "$elapsed" <= 6 )) ; then #just 6 seconds
            COMPPOSIB=( ${COMPPOSIB[@]} `cat "$cachefile"` )
            if [[ ${#COMPPOSIB[@]} == 0 ]] ; then
                COPPOSIB=( EMPTY LIST )
            fi
            touch "$cachefile"
            return 0;
        else
            echo "" > "$cachefile"
        fi
    else 
        echo "" > "$cachefile"
    fi
    #Call list command
    old_IFS=$IFS
    IFS=$'\n'
    cmdrslt=( $(eval $cmdname) )
    IFS=$old_IFS
    #Read values
    if [[ $? == 0 ]] ; then 
        if [[ "${cmdrslt[0]}" == Nothing?to* ]] || [[ "${cmdrslt[0]}" ==  No?such?local?command* ]] ; then
            echo "" > "$cachefile"
            COPPOSIB=( EMPTY LIST )
            return 0
        else
            alternatives=""
            for line in "${cmdrslt[@]}" ; do
                alternatives="$alternatives ${line%% *}"
            done
            echo "$alternatives" > "$cachefile"
            COMPPOSIB=( ${COMPPOSIB[@]} $alternatives )
            return 0
        fi
    else
        return 1
    fi
}

_nclnac_argTarget () {
    _nclnac_cliList list-clusters
    _nclnac_cliList list-instances
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-domains
                    fi
                    ;;
                'change-admin-password')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            if [[ $prev == "--domain_name" ]] ; then
                                _nclnac_cliList list-domains
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--cluster" ]] ; then
                                _nclnac_cliList list-clusters
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_argTarget
                    fi
                    ;;
                'create-http-lb')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--httpsrouting" "--monitor" "--routecookie" "--autoapplyenabled" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_argTarget
                    fi
                    ;;
                'create-http-listener')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--xpowered" "--securityenabled" "--enabled" "--secure" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--cluster" ]] ; then
                                _nclnac_cliList list-clusters
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--cluster" ]] ; then
                                _nclnac_cliList list-clusters
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-admin-objects
                    fi
                    ;;
                'delete-application-ref')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--cascade" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" "--cascade" 
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-application-refs
                    fi
                    ;;
                'delete-audit-module')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-audit-modules
                    fi
                    ;;
                'delete-auth-realm')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-auth-realms
                    fi
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
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-clusters
                    fi
                    ;;
                'delete-config')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-configs
                    fi
                    ;;
                'delete-connector-connection-pool')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--cascade" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" "--cascade" 
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-connector-connection-pools
                    fi
                    ;;
                'delete-connector-resource')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-connector-resources
                    fi
                    ;;
                'delete-connector-security-map')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--poolname" "--target" 
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-connector-security-maps
                    fi
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
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-connector-work-security-maps
                    fi
                    ;;
                'delete-context-service')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-context-services
                    fi
                    ;;
                'delete-custom-resource')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-custom-resources
                    fi
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
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-domains
                    fi
                    ;;
                'delete-file-user')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--authrealmname" "--target" 
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-file-users
                    fi
                    ;;
                'delete-http')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_argTarget
                    fi
                    ;;
                'delete-http-lb')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-http-lbs
                    fi
                    ;;
                'delete-http-lb-config')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-http-lb-configs
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
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_argTarget
                    fi
                    ;;
                'delete-http-listener')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--secure" "--target" 
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-http-listeners
                    fi
                    ;;
                'delete-http-redirect')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-iiop-listeners
                    fi
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
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-instances
                    fi
                    ;;
                'delete-jacc-provider')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-jacc-providers
                    fi
                    ;;
                'delete-javamail-resource')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-javamail-resources
                    fi
                    ;;
                'delete-jdbc-connection-pool')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--cascade" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--cascade" "--target" 
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-jdbc-connection-pools
                    fi
                    ;;
                'delete-jdbc-resource')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-jdbc-resources
                    fi
                    ;;
                'delete-jmsdest')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--destType -T" "--target" 
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-jmsdest
                    fi
                    ;;
                'delete-jms-host')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-jms-hosts
                    fi
                    ;;
                'delete-jms-resource')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-jms-resources
                    fi
                    ;;
                'delete-jndi-resource')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-jndi-resources
                    fi
                    ;;
                'delete-jvm-options')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--profiler" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" "--profiler" 
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-jvm-options
                    fi
                    ;;
                'delete-lifecycle-module')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-lifecycle-modules
                    fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-log-levels
                    fi
                    ;;
                'delete-managed-executor-service')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-managed-executor-services
                    fi
                    ;;
                'delete-managed-scheduled-executor-service')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-managed-scheduled-executor-services
                    fi
                    ;;
                'delete-managed-thread-factory')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--layer" "--target" 
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-message-security-providers
                    fi
                    ;;
                'delete-module-config')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-network-listeners
                    fi
                    ;;
                'delete-node-config')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-nodes-config
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
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-nodes-dcom
                    fi
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
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-nodes-ssh
                    fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-protocols
                    fi
                    ;;
                'delete-protocol-filter')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--protocol" "--target" 
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-protocol-filters
                    fi
                    ;;
                'delete-protocol-finder')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--protocol" "--target" 
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-protocol-finders
                    fi
                    ;;
                'delete-resource-adapter-config')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-resource-adapter-configs
                    fi
                    ;;
                'delete-resource-ref')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-resource-refs
                    fi
                    ;;
                'delete-ssl')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-threadpools
                    fi
                    ;;
                'delete-transport')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-transports
                    fi
                    ;;
                'delete-virtual-server')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-virtual-servers
                    fi
                    ;;
                'deploy')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--force" "--precompilejsp" "--verify" "--createtables" "--dropandcreatetables" "--uniquetablenames" "--enabled" "--generatermistubs" "--availabilityenabled" "--asyncreplication" "--keepreposdir" "--keepfailedstubs" "--isredeploy" "--logReportedErrors" "--keepstate" "--upload" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--isundeploy" "--target" "--keepreposdir" "--isredeploy" "--droptables" "--cascade" "--properties" "--keepstate" 
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-components
                    fi
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
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_argTarget
                    fi
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
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_argTarget
                    fi
                    ;;
                'disable-monitoring')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-secure-admin-internal-users
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
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-secure-admin-principals
                    fi
                    ;;
                'enable')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
                            break
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" 
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-components
                    fi
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
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_argTarget
                    fi
                    ;;
                'enable-http-lb-server')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_argTarget
                    fi
                    ;;
                'enable-monitoring')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--mbean" "--dtrace" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_argTarget
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
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_argTarget
                    fi
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
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_argTarget
                    fi
                    ;;
                'list-audit-modules')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_argTarget
                    fi
                    ;;
                'list-auth-realms')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_argTarget
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
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-domains
                    fi
                    ;;
                'list-batch-job-executions')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--terse" "-t" "--header" "-h" "--long" "-l" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_argTarget
                    fi
                    ;;
                'list-configs')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_argTarget
                    fi
                    ;;
                'list-connector-connection-pools')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_argTarget
                    fi
                    ;;
                'list-connector-resources')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_argTarget
                    fi
                    ;;
                'list-connector-security-maps')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--long" "--verbose" "-l" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_argTarget
                    fi
                    ;;
                'list-custom-resources')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_argTarget
                    fi
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
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_argTarget
                    fi
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
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_argTarget
                    fi
                    ;;
                'list-iiop-listeners')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_argTarget
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
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_argTarget
                    fi
                    ;;
                'list-javamail-resources')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_argTarget
                    fi
                    ;;
                'list-jdbc-resources')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_argTarget
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
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_argTarget
                    fi
                    ;;
                'list-jms-hosts')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_argTarget
                    fi
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
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_argTarget
                    fi
                    ;;
                'list-jndi-resources')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_argTarget
                    fi
                    ;;
                'list-log-attributes')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_argTarget
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
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_argTarget
                    fi
                    ;;
                'list-managed-executor-services')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_argTarget
                    fi
                    ;;
                'list-managed-scheduled-executor-services')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_argTarget
                    fi
                    ;;
                'list-managed-thread-factories')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_argTarget
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
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_argTarget
                    fi
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
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_argTarget
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_argTarget
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
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_argTarget
                    fi
                    ;;
                'list-resource-refs')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_argTarget
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
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_argTarget
                    fi
                    ;;
                'list-system-properties')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_argTarget
                    fi
                    ;;
                'list-threadpools')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_argTarget
                    fi
                    ;;
                'list-timers')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_argTarget
                    fi
                    ;;
                'list-transports')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            break
                    fi
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_argTarget
                    fi
                    ;;
                'list-virtual-servers')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_argTarget
                    fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--name" ]] ; then
                                _nclnac_cliList list-applications
                            fi
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-domains
                    fi
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
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-instances
                    fi
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
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-instances
                    fi
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
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-domains
                    fi
                    ;;
                'rollback-transaction')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-clusters
                    fi
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
                    _nclnac_addNonexistMulti "$prev" "--verbose -v" "--upgrade" "--watchdog -w" "--debug -d" "--dry-run -n" "--domaindir" 
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-domains
                    fi
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
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-instances
                    fi
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
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-instances
                    fi
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
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-clusters
                    fi
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
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-domains
                    fi
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
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-instances
                    fi
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
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-instances
                    fi
                    ;;
                'undeploy')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                        if ! _nclnac_containsElement "$prev" "--keepreposdir" "--isredeploy" "--droptables" "--cascade" "--keepstate" ; then #prev is non boolean argument - user must porvide value.
                            COMPPOSIB=()
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
                            break
                        fi
                        COMPPOSIB=( ${COMPPOSIB[@]} "true" "false" )
                    fi
                    #Add unused single values
                    _nclnac_addNonexistMulti "$prev" "--target" "--keepreposdir" "--isredeploy" "--droptables" "--cascade" "--properties" "--keepstate" 
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-applications
                    fi
                    ;;
                'unfreeze-transaction-service')
                    commandisdefined=true
                    #prev is argument
                    if [[ $prev == -* ]] ; then
                            COMPPOSIB=()
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                            if [[ $prev == "--target" ]] ; then
                                _nclnac_argTarget
                            fi
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
                    #Special operator algorithm
                    if [[ $cur != -* ]] ; then
                        _nclnac_cliList list-domains
                    fi
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