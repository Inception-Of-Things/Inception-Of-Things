# Inception-Of-Things

___System admin project for 42 school___   

## Table of Content

1. [Part 1: K3s and Vagrant](#part-1)
2. [Part 2: K3s and three simple applications](#part-2)
3. [Part 3: K3d and Argo CD](#part-3)

## Part 1: K3s and Vagrant   <a href="https://www.vagrantup.com/" ><img src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/vagrant/vagrant-original-wordmark.svg" height=50 width=50 align="right"/><a/> <a href="https://k3s.io/" > <img src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/k3s/k3s-plain-wordmark.svg" height=50 width=50 align="right"><a/> <a name="part-1"><a/>

___This project involves deploying two nodes ( server / agent ) using **K3s**.___   

### Project :
 
Here we have to create with two Virtual Machines via a **Vagrantfile** and **Virtualbox**, set up a private network and ```192.168.56.110``` as IP.  
In both VM we have to install **K3s**, a lightweight **Kubernetes** distribution, in the one anoted with ``S`` we create a **server node** and in the one anoted with ``SW`` we create an **agent node**.
We respectfully set their IP to ``192.168.56.110`` and ``192.168.56.111``

### Requirement : <a name="requirement-part-1"><a/>
>[!IMPORTANT]
> Vagrant does not support latest version of virtual box yet, so you need to download a version ``< 7.1``

>[!TIP]
> You can check the version of you current virtualbox using ```virtualbox -h```  
> Here is a link to a supported version of [Virtualbox](https://www.virtualbox.org/wiki/Download_Old_Builds_7_0)

* **Vagrant**
* **Virtualbox**

### Start :
To start this project you will need to go inside the ``p1/`` folder and use ```vagrant up```.

### Test : 
1. Go inside the VM where the server node is setup:
   ```vagrant ssh asimonS```
2. You can check that k3s is installed by using: ``k3s -v``
3. Use the kubernetes command:
``` sudo kubectl get node -o wide```

this should prompt:
> insert img

## Part 2: K3s and three simple applications  <a href="https://www.vagrantup.com/" ><img src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/vagrant/vagrant-original-wordmark.svg" height=50 width=50 align="right"/><a /> <a href="https://k3s.io/" > <img src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/k3s/k3s-plain-wordmark.svg" height=50 width=50 align="right"><a/> <a name="part-2"><a/>

___This project involves deploying and managing web applications using **K3s**.___  

### Project :

The objective is to set up a **K3s** instance on a virtual machine of your choice, with the latest stable version of your preferred Linux distribution and **K3s** installed in **server mode**.  

Once the environment is set up, the project requires you to deploy three web applications of your choice onto the **K3s cluster**.  
These applications should be configured to be accessible via a specific IP address ``192.168.56.110``.  
When a client inputs the ip ``192.168.56.110`` in his web browser with the **HOST** ``app1.com``, the server must display the app1.  
When the **HOST** ``app2.com`` is used, the server must display the app2. 

Otherwise, the app3 will be selected by default

### Requirement :
[___Same as in part 1___](#requirement-part-1)

### Start :
To start this project you will need to go inside the ``p2/`` folder and use ``vagrant up``.

### Test : 
>[!NOTE]
> All our confs file for app 1 to 3 and our Ingress are in the ``confs/`` folder.

1. Go inside the **VM** using : ``vagrant ssh idouidiSW``
2. Use ``sudo kubectl get all -n kube-system``

You should have :
> insert img

##  Part 3: K3d and Argo CD <a name="part-3"><a/>


## Stack

<div >

<a href="https://www.vagrantup.com/"><img src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/vagrant/vagrant-original.svg" width=40 height=40/><a/>
<a href="https://k3s.io/"><img src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/k3s/k3s-original.svg" width=40 height=40/><a/>

</div>
