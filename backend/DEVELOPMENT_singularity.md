# THIS NOT WORKS:

## Using singularity run from within the Docker container
**It is strongly recommended that you don't use the Docker container for running Singularity images**, only for creating them, since the Singularity command runs within the container as the root user.


# Build in Singularity

```
cd build\
```

Building containers from SingularityCE definition files
```
cd search_engine
sudo singularity  build  search_engine.sif  search_engine.def

cd shifts
sudo singularity  build  shifts.sif    shifts.def

cd solver
sudo singularity  build  solver.sif  solver.def

cd refrag
sudo singularity  build  refrag.sif  refrag.def
```


Building container in sandbox from SingularityCE definition files
```
cd search_engine
sudo  singularity  build  --sandbox  /tmp/search_engine    search_engine.def

cd shifts
sudo  singularity  build  --sandbox  /tmp/shifts  shifts.def

cd solver
sudo  singularity  build  --sandbox  /tmp/solver  solver.def

cd refrag
sudo  singularity  build  --sandbox  /tmp/refrag  refrag.def
```



You can build into the same sandbox container multiple times (though the results may be unpredictable, and under most circumstances, it would be preferable to delete your container and start from scratch):
```
cd search_engine
sudo singularity  build  --update  --sandbox  /tmp/search_engine  search_engine.def

cd shifts
sudo singularity  build  --update  --sandbox  /tmp/shifts  shifts.def

cd solver
sudo singularity  build  --update  --sandbox  /tmp/solver  solver.def
```


In this case, we're running singularity build with sudo because installing software with apt-get, as in the %post section, requires the root privileges.

By default, when you run SingularityCE, you are the same user inside the container as on the host machine. Using sudo on the host, to acquire root privileges, ensures we can use apt-get as root inside the container.

Using a fake root (for non-admin users)
```
singularity build --fakeroot ptm_compass.sif ptm_compass.def
```


# Interacting with images: Shell
The shell command allows you to spawn a new shell within your container and interact with it as though it were a virtual machine.

```
singularity shell search_engine.sif

singularity shell shifts.sif
```

Enable to write in folder container (sandbox)
```
sudo singularity shell --writable /tmp/search_engine

sudo singularity shell --writable /tmp/shifts
```

Enable to write in file container
```
sudo singularity shell --writable-tmpfs search_engine.sif

sudo singularity shell --writable-tmpfs shifts.sif
```

Bind disk
```
singularity shell --bind /mnt/tierra:/mnt/tierra search_engine.sif

singularity shell --bind /mnt/tierra:/mnt/tierra shifts.sif
```


# Open the repositories (shifts and solver) using the Visual Studio Code:
```
code /home/jmrodriguezc/solver/usr/local/shifts_v4/
```

# Executing Commands
The *exec* command allows you to execute a custom command within a container by specifying the image file.

```
singularity exec -w solver python /usr/local/shifts_v4/SHIFTSadapter.py 
```


```
singularity exec --bind /mnt/tierra:/mnt/tierra solver python /usr/local/shifts_v4/SHIFTSadapter.py \
-i/home/jmrodriguezc/projects/PTMs_nextflow/tests/test1/Recom/*.txt

singularity exec --bind /mnt/tierra:/mnt/tierra solver python /usr/local/shifts_v4/DuplicateRemover.py \
-i/home/jmrodriguezc/projects/PTMs_nextflow/tests/test1/Recom/*_SHIFTS.feather -s scan -n num -x xcorr_corr -p sp_score


singularity exec --bind /mnt/tierra:/mnt/tierra solver python /usr/local/shifts_v4/DMcalibrator.py \
-i/home/jmrodriguezc/projects/PTMs_nextflow/tests/test1/Recom/*_Unique.feather \
-c/home/jmrodriguezc/projects/PTMs_nextflow/tests/test1/SHIFTS.ini


singularity exec --bind /mnt/tierra:/mnt/tierra solver python /usr/local/shifts_v4/PeakModeller.py \
-i/home/jmrodriguezc/projects/PTMs_nextflow/tests/test1/Recom/*_calibrated.feather \
-c/home/jmrodriguezc/projects/PTMs_nextflow/tests/test1/SHIFTS.ini


singularity exec --bind /mnt/tierra:/mnt/tierra solver python /usr/local/shifts_v4/PeakInspector.py -gui



```



