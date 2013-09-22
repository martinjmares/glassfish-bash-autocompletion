Bash custom autocompletion for GlassFish 4
==================================

If you are using GlassFish 4 CLI (asadmin utility) on bash then you can do TAB and TAB-TAB for autocomplete your command names, parameters and sometimes also values.

## Download

Best is to use your git: [https://github.com/martinjmares/glassfish-bash-autocompletion.git](https://github.com/martinjmares/glassfish-bash-autocompletion.git)

Or you can also use [this direct link to the raw file](https://raw.github.com/martinjmares/glassfish-bash-autocompletion/master/bash_completion.d/completion_asadmin.bash)


## Install

Simply _source_ provided script into your current TTY. Of course you can do it in your _.bashrc_ or _.profile_ file.

~~~
source completion_asadmin.bash
//OR
. completion_asadmin.bash
~~~

Some Linux distributions contains standard directory for completion scripts which are automatically sourced into TTYs.  Directory */etc/bash_completion.d* is quite popular.

## Main features

* Completes command names: _asadmin deplo&lt;TAB&gt;_
* Completes asadmin parameters: _asadmin --passwor&lt;TAB&gt;_
* Completes command parameter names: _asadmin deploy --&lt;TAB&gt;&lt;TAB&gt;_
* Completes parameter names only on correct position. It means not if parameter value is expected.
* Offers parameter name only if it was not used on other place of the same command line. Not applied on multi-parameters (new feature of GlassFish 4 CLI).
* Completes operands and parameter values for some cases based on data dynamically reached from glassfish: _asadmin undeploy &lt;TAB&gt;&lt;TAB&gt;_ or _asadmin start-cluster &lt;TAB&gt;&lt;TAB&gt;_

