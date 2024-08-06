#!/bin/bash

set -e
cat <<__EOF__

======================================================================
 This shell script uses CONDA to install all required AI development
 packages. You must have already created and activated your
 conda environment using:

	conda create -n ai python=3.10
	conda activate ai

 BEFORE using this script.  Press CTRL-C to cancel to ENTER to continue.

 Author: Joff Thyer and Derek Banks (c) 2024

======================================================================

-< Press ENTER to Continue or CTRL-C to QUIT >-

__EOF__
read
if [[ `uname -r` == *"WSL2"* ]]; then
	echo "[*] ##############################################"
	echo "[*] ## Target System is WSL2: using PIP method. ##"
	echo "[*] ##############################################"
	echo "[+] Installing: cudatoolkit for WSL2"
	conda install -yq cudatoolkit >/dev/null 2>&1
	echo "[+] Installing all packages from requirements.wsl2 using PIP"
	pip install -r requirements.wsl2 2>&1
	export LD_LIBRARY_PATH=`echo $(find $HOME/miniconda3/envs/$CONDA_DEFAULT_ENV/lib/python3.10/site-packages/nvidia -type d -name lib) | sed 's/ /:/g'`
	 (cat $HOME/.bashrc | grep -q LD_LIBRARY_PATH) || cat <<__EOF__ >>$HOME/.bashrc
export LD_LIBRARY_PATH=\`echo \$(find $HOME/miniconda3/envs/$CONDA_DEFAULT_ENV/lib/python3.10/site-packages/nvidia -type d -name lib) | sed 's/ /:/g'\`
__EOF__
	echo "[+] Installing: torch"
	pip install torch==2.3.1 2>&1
	python -c 'import tensorflow as tf; dev=tf.config.list_physical_devices("GPU"); print(f"[+] GPU Device Check: {dev}")' 2>/dev/null
else
	echo "[*] #######################################################"
	echo "[*] ## Target System UNIX/MacOS/BSD: using conda method. ##"
	echo "[*] #######################################################"
	echo "[+] Installing: jupyter"
	conda install -yq jupyter >/dev/null 2>&1
	echo "[+] Installing: huggingface_hub, transformers, pytorch, datasets"
	conda install -yq huggingface_hub transformers pytorch datasets >/dev/null 2>&1
	echo "[+] Installing: pandas, numpy, matplotlib"
	conda install -yq pandas numpy matplotlib >/dev/null 2>&1
	echo "[+] Installing: nltk, seaborn, plotly"
	conda install -yq nltk seaborn plotly >/dev/null 2>&1
	echo "[+] Installing: scikit-learn"
	conda install -yq scikit-learn >/dev/null 2>&1
	echo "[+] Installing: tensorflow"
	conda install -yq tensorflow >/dev/null 2>&1
fi
echo ""
echo "#############################################"
echo "### Successfully Completed Installations! ###"
echo "#############################################"
