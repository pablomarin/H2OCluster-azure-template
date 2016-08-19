# h2o-azure-template
Deploys a H2O cluster in Azure , using ARM template

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fpablomarin%2Fh2o-azure-template%2Fmaster%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fpablomarin%2Fh2o-azure-template%2Fmaster%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>

This template creates a 'n' node H2O cluster using <a href="https://azure.microsoft.com/en-us/documentation/articles/machine-learning-data-science-linux-dsvm-intro/" target="_blank"> Linux Datascience VMs</a>. Use the scaleNumber parameter to specify the number of nodes in the cluster.

It uses DS_v2 type (<a href="https://azure.microsoft.com/en-us/documentation/articles/storage-premium-storage/" target="_blank">Premiun Storage SSD drives</a>) virtual machines for CPU and I/O intensive workloads.
