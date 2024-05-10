
# Command lines for Dataset

1. List all dataset instances on a nextflow server
```
bash dataset/query.sh http://localhost:8080
```

2. Create a dataset instance
```
bash dataset/create.sh http://localhost:8080 'experiment1'
```

3. Upload dataset data for a dataset instance on a nextflow server
```
bash dataset/upload.sh http://localhost:8080 66212647c63490ba135050a0 "directory-path" "raw_files" /mnt/tierra/nf-SearchEngine/tests/test1/inputs/raw_files/Jurkat_Fr1.raw

bash dataset/upload.sh http://localhost:8080 66212647c63490ba135050a0 file-path exp_table /mnt/tierra/nf-PTM-compass/tests/test1/inputs/exp_table.txt
```

4. Get a dataset instance on a nextflow server
```
bash dataset/get.sh http://localhost:8080 66212647c63490ba135050a0
```

5. Edit a dataset instance on a nextflow server
```
bash dataset/edit.sh http://localhost:8080 66212647c63490ba135050a0 '{"name":"new_name", "description": "Short description", "auth": "jmrodriguezc"}'
```

6. Delete a dataset instance on a nextflow server
```
bash dataset/delete.sh http://localhost:8080 66212647c63490ba135050a0
```

Test example for nf-PTM-compass
```
bash dataset/create.sh http://localhost:8080 'dataset_1'
bash dataset/upload.sh http://localhost:8080 663ca7a4d61efcf1dbf1c727 "directory-path" "re_files" "/mnt/tierra/nf-PTM-compass/tests/test1/inputs/re_files/JAL_Noa3_iT_ALL.txt"
bash dataset/upload.sh http://localhost:8080 663ca7a4d61efcf1dbf1c727 "directory-path" "re_files" "/mnt/tierra/nf-PTM-compass/tests/test1/inputs/re_files/JAL_NoCD_iTR_ALL.txt"
bash dataset/upload.sh http://localhost:8080 663ca7a4d61efcf1dbf1c727 "file-path" "exp_table" "/mnt/tierra/nf-PTM-compass/tests/test1/inputs/exp_table.txt"
bash dataset/upload.sh http://localhost:8080 663ca7a4d61efcf1dbf1c727 "file-path" "database" "/mnt/tierra/nf-PTM-compass/tests/test1/inputs/database.fasta"
bash dataset/upload.sh http://localhost:8080 663ca7a4d61efcf1dbf1c727 "file-path" "params-file" "/mnt/tierra/nf-PTM-compass/tests/test1/inputs/params.ini"
bash dataset/upload.sh http://localhost:8080 663ca7a4d61efcf1dbf1c727 "file-path" "sitelist_file" "/mnt/tierra/nf-PTM-compass/tests/test1/inputs/sitelist.txt"
bash dataset/upload.sh http://localhost:8080 663ca7a4d61efcf1dbf1c727 "file-path" "groupmaker_file" "/mnt/tierra/nf-PTM-compass/tests/test1/inputs/groupmaker.txt"
```


# Command lines for Workflow

1. List all workflow instances on a nextflow server
```
bash workflow/query.sh http://localhost:8080
```

2. Create a workflow instance
```
bash workflow/create.sh http://localhost:8080 \
'{"pipeline": "https://github.com/CNIC-Proteomics/nf-PTM-compass",
"revision": "main",
"profiles": "guess",
"description": "test workflow",
"params": [
    {"name": "re_files", "type": "directory-path", "value": "663ca7a4d61efcf1dbf1c727/re_files/*"},
    {"name": "exp_table", "type": "file-path", "value": "663ca7a4d61efcf1dbf1c727/exp_table.txt"},
    {"name": "database", "type": "file-path", "value": "663ca7a4d61efcf1dbf1c727/database.fasta"},
    {"name": "decoy_prefix", "type": "string", "value": "DECOY_"},
    {"name": "params-file", "type": "file-path", "value": "663ca7a4d61efcf1dbf1c727/database.fasta"}
]
}'
```

3. Launch a workflow instance on a nextflow server
```
bash workflow/launch.sh http://localhost:8080 663cb088c59bdf69dc2daedc
```

4. Get the log of a workflow instance on a nextflow server
```
bash workflow/log.sh http://localhost:8080 663cb088c59bdf69dc2daedc
```

5. Create a workflow instance
```
bash workflow/edit.sh http://localhost:8080 663cb088c59bdf69dc2daedc \
'{"params": [
    {"name": "--re_files", "type": "directory-path", "value": "663ca7a4d61efcf1dbf1c727/re_files/*"},
    {"name": "--exp_table", "type": "file-path", "value": "663ca7a4d61efcf1dbf1c727/exp_table.txt"},
    {"name": "--database", "type": "file-path", "value": "663ca7a4d61efcf1dbf1c727/database.fasta"},
    {"name": "--decoy_prefix", "type": "string", "value": "DECOY_"},
    {"name": "--params_file", "type": "file-path", "value": "663ca7a4d61efcf1dbf1c727/params-file.ini"},
    {"name": "--sitelist_file", "type": "file-path", "value": "663ca7a4d61efcf1dbf1c727/sitelist_file.txt"},
    {"name": "--groupmaker_file", "type": "file-path", "value": "663ca7a4d61efcf1dbf1c727/groupmaker_file.txt"}
]
}'
```

