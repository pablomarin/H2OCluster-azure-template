# h2o-azure-template
Deploys a H2O cluster in Azure , using ARM template

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fpablomarin%2Fh2o-azure-template%2Fmaster%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fpablomarin%2Fh2o-azure-template%2Fmaster%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>

This template creates a 'n' node H2O cluster using <a href="https://azure.microsoft.com/en-us/documentation/articles/machine-learning-data-science-linux-dsvm-intro/" target="_blank"> Linux Datascience VMs</a>. Use the <b>scaleNumber</b> parameter to specify the number of nodes in the cluster.

This template will automatically: download the latest stable version of H2O on each node and run the h2o.jar with the max amount of RAM available on the each node.

This template lets you select from DS_v2 VM types (<a href="https://azure.microsoft.com/en-us/documentation/articles/storage-premium-storage/" target="_blank">Premiun Storage SSD drives</a>) for CPU and I/O intensive workloads.

The Linux Data Science Virtual Machine is ideal to use as a base for H2O because it comes with a collection of tools pre-installed that are commonly used for doing data analytics and machine learning. The key software components included are:

- Microsoft R Open
- Anaconda Python distribution (v 2.7 and v3.5), including popular data analysis libraries
- Jupyter Notebook (R, Python)
- Azure Storage Explorer
- Azure Command-Line for managing Azure resources
- PostgresSQL Database
- Machine learning Tools
    - [Computational Network Toolkit (CNTK)](https://github.com/Microsoft/CNTK): a deep learning software from Microsoft Research
    - [Vowpal Wabbit](https://github.com/JohnLangford/vowpal_wabbit): a fast machine learning system supporting techniques such as online, hashing, allreduce, reductions, learning2search, active, and interactive learning.
    - [XGBoost](https://xgboost.readthedocs.org/en/latest/): a tool providing fast and accurate boosted tree implementation
    - [Rattle](http://rattle.togaware.com/) (the R Analytical Tool To Learn Easily) : a tool that makes getting started with data analytics and machine learning in R easy with a GUI-based data exploration and modeling with automatic R code generation. 
- Azure SDK in Java, Python, node.js, Ruby, PHP
- Libraries in R and Python for use in Azure Machine Learning and other Azure services
- Development tools and editors (Eclipse, Emacs, gedit, vi)

### Jupyter Notebook 

The Anaconda distribution also comes with a Jupyter notebook, an environment to share code and analysis. The Jupyter Notebook is accessed through JupyterHub. You log in using your local Linux username and password.

The Jupyter notebook server has been pre-configured with Python 2, Python 3 and R kernels. There is a desktop icon named "Jupyter Notebook to launch the browser to access the Notebook server. If you are on the VM via SSH or X2go client you can also visit [https://localhost:8000/](https://localhost:8000/) to access the Jupyter notebook server.

-->Continue if you get any certificate warnings. 

You can access the Jupyter notebook server from any host. Just type in *https://\<VM DNS name or IP Address\>:8000/* 

-->Port 8000 is opened in the firewall by default when the VM is provisioned.

We have packaged a few sample notebooks - one in Python and one in R. You can see the link to the samples on the notebook home page after you authenticate to the Jupyter notebook using your local Linux username and password. You can create a new notebook by selecting **New** and then the appropriate language kernel. If you don't see the **New** button, click on the **Jupyter** icon on the top left to go to the home page of the notebook server. 

### Microsoft R Open 
R is one of the most popular languages for data analysis and machine learning. If you wish to use R for your analytics, the VM has Microsoft R Open (MRO) with the Math Kernel Library (MKL). The MKL optimizes math operations common in analytical algorithms. MRO is 100% compatible with CRAN-R and any of the R libraries published in CRAN can be installed on the MRO. You can edit your R programs in one of the default editors like vi, Emacs or gedit. You are also able to download and use other IDEs as well such as [RStudio](http://www.rstudio.com). For your convenience, a simple script (installRStudio.sh) is provided in the **/dsvm/tools** directory that installs RStudio. If you are using the Emacs editor, note that the Emacs package ESS (Emacs Speaks Statistics), which simplifies working with R files within Emacs editor, has been pre-installed. 

To launch R, you just type ***R*** in the shell. This takes you to an interactive environment. To develop your R program you typically use an editor like Emacs or vi or gedit and then run the scripts within R. If you install RStudio, you have a full graphical IDE environment to develop your R program. 

There is also an R script for you to install the [Top 20 R packages](http://www.kdnuggets.com/2015/06/top-20-r-packages.html) if you want. This script can be run once you are in the R interactive interface, which can be entered (as mentioned) by typing *R* in the shell.  

### Python
For development using Python, Anaconda Python distribution 2.7 and 3.5 has been installed. This distribution contains the base Python along with about 300 of the most popular math, engineering, and data analytics packages. You can use the default text editors. In addition you can use Spyder a Python IDE that is bundled with Anaconda Python distributions. Spyder needs a graphical desktop or X11 forwarding. A shortcut to Spyder is provided in the graphical desktop. 

Since we have both Python 2.7 and 3.5, you need to specifically activate the desired Python version you want to work on in the current session. The activation process sets the PATH variable to the desired version of Python. 

To activate Python 2.7, run the following from the shell:

	source /anaconda/bin/activate root

Python 2.7 is installed at */anaconda/bin*. 

To activate Python 3.5, run the following from the shell:

	source /anaconda/bin/activate py35


Python 3.5 is installed at */anaconda/envs/py35/bin*

Now to invoke python interactive session just type ***python*** in the shell. If you are on a graphical interface or have X11 forwarding set up, you can type ***spyder*** command to launch the Python IDE. 
