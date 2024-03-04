
# Service Monitoring with Icinga 2

[Icinga 2](https://icinga.com/docs/icinga-2/latest/doc/01-about/) can be used to check if the services are running. In addition, Icinga 2 can be used to check the status of a server. This document explains and shows examples for creating a check, called as a "service" in Icinga. 

## Installing Icinga 2

Icinga 2 is installed on a Linux-based server as a package. Please refer to [the official documentation](https://icinga.com/docs/icinga-2/latest/doc/02-installation/) for installing Icinga 2.


## Creating Services

Once Icinga 2 is installed, there will be a directory, `/etc/icinga2/`, to create and store configuration files. Under this directory, you will find `conf.d` directory where the configurations are made, which includes the file `hosts.conf` (so the exact placement of the file is `/etc/icinga2/conf.d/hosts.conf`). Note that you will need the root permission to be able to navigate to this directory. 

In `hosts.conf`, you will see multiple hosts are defined for multiple servers. Find the server where the Docker containers are deployed. The host will have its code chunk starting as `object Host` and the name of the server. This line is followed by curly brackets inside of which the checks are configured. 

Check are added inside of the host's code chunk. [`http_vhosts`](https://icinga.com/docs/icinga-2/latest/doc/10-icinga-template-library/#http) command can be used to check if the URL has the expected string. A check has the following form:

```
vars.http_vhosts["<check_name>"] = {
    http_uri = "<additional_diretory_to_the_url>"
    http_vhost = "<the_main_url>"
    http_string = "<expected_string>"
    http_onredirect = "follow"
}
```

Note that the code above is put inside of the host's code chunk which is indented by one level in the `hosts.conf`. So, it is recommended to put the code for a check with one level of indentation.

The options in the code above and their functions are as follows. First, one can name a service (again, "service" referring to an Icinga 2 check) by defining the name in the square brackets after the `vars.http_vhosts`. The following options are required to define a URL to be checked and the its expected content. `http_vhost` defines the URL that you want to check, and `http_uri` defines if there are any additional directories to the URL (see below for an example). Then, `http_string` defines the expected string at the URL. Finally, `http_ondirect` is set to `"follow"` to allow the check to find the certificated URL. 

Below are two examples we currently have. 

```
vars.http_vhosts["http_aopwiki"] = {
    http_uri = "/"
    http_vhost = "aopwiki.cloud.vhp4safety.nl"
    http_string = "AOP-Wiki"
    http_onredirect = "follow"
}
```

In the example above, the name of the check is set to `http_aopwiki` and checks if the AOP-Wiki RDF is running as expected. The `http_uri` option is set to `"/"` as there are no additional directories to the service URL, `"aopwiki.cloud.vhp4safety.nl"`. Also note here that you do not need to include `http` or `https` at the beginning of the URL. Finally, the expected string is `"AOP-Wiki"` which is set to the `http_string` option.

```
vars.http_vhosts["http_bridgedb_webservice"] = {
    http_uri = "/swagger"
    http_vhost = "bridgedb.cloud.vhp4safety.nl"
    http_string = "/swagger/swagger.json"
    http_onredirect = "follow"
}
```

The second example above is almost the same as the first one with one exception. The second check, named as `"http_bridgedb_webservice"` that runs at `"bridgedb.cloud.vhp4safety.nl"` has an extra directory where the webservice runs. This extra directory `"/swagger"` is set to the `http_uri` option. 


## Applying Changes in Configuration Files

Once you made changes in the configuration, such as adding a new service or making a change in an existing service, you will need to restart Icinga to apply those changes. Restarting Icinga is made by running the following command on the host's terminal:

`systemctl restart icinga2`

