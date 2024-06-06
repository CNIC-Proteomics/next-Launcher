/*
 * Import libraries
 */

import {
    BACKEND_URL, 
    MAX_FILE_SIZE
} from '../constants';
import React, { useState, useRef, useEffect } from 'react';
import { InputText } from 'primereact/inputtext';
import { Button } from 'primereact/button';
// import { DataTable } from 'primereact/datatable';
// import { Column } from 'primereact/column';
import { FileUpload } from 'primereact/fileupload';


import { Toast } from 'primereact/toast';
import { ProgressBar } from 'primereact/progressbar';
import { Tooltip } from 'primereact/tooltip';
import { Tag } from 'primereact/tag';



/*
 * Functions
 */

/* Create section to upload files from a folder */
// export const FolderDatasetUpload = ({properties}) => {

//     const folderInputRef = useRef(null);
  
//     const handleFolderSelect = () => {
//       folderInputRef.current.click();
//     };
  
//     const onFolderChange = (e) => {
//       const files = Array.from(e.target.files);
//       console.log('Selected files:', files);
//     };
  
//     return (
//         <div className="flex flex-column gap-2">
//             <label>{properties.description}</label>
//             <div className="p-inputgroup flex">
//                 <Button label="Select Folder" icon="pi pi-folder-open" onClick={handleFolderSelect} className="p-mr-2" />
//                 <InputText placeholder='' />
//                 <input
//                     type="file"
//                     ref={folderInputRef}
//                     style={{ display: 'none' }}
//                     webkitdirectory="true"
//                     mozdirectory="true"
//                     directory="true"
//                     onChange={onFolderChange}
//                 />
//             </div>
//             <small id={`${properties.title}-help`}>{properties.help_text}</small>
//         </div>
//     );
// };

/* Create section to upload a single file */
export const FileDatasetUpload = ({properties}) => {
    const fileInputRef = useRef(null);
  
    const handleFileSelect = () => {
      fileInputRef.current.click();
    };
    
    const onFileChange = (e) => {
      const file = e.target.files[0];
      console.log('Selected file:', file);
    };
    return (
        <div className="flex flex-column gap-2">
            <label>{properties.description}</label>
            <div className="p-inputgroup flex">
                <Button label="Select File" icon="pi pi-file" onClick={handleFileSelect} />
                <InputText placeholder='' />
                <input
                type="file"
                ref={fileInputRef}
                style={{ display: 'none' }}
                onChange={onFileChange}
                />
            </div>
            <small id={`${properties.title}-help`}>{properties.help_text}</small>
        </div>
    );
};

/* Create section to string parameters */
export const StringDataset = ({properties}) => {
    const [textValue, setTextValue] = useState('');
    return (
        <div className="flex flex-column gap-2">
            <label htmlFor={properties.title} >{properties.description}</label>
            <div className="p-inputgroup flex">
                <InputText id={properties.title} aria-describedby={`${properties.title}-help`} value={properties.default} onChange={(e) => setTextValue(e.target.value)} />
            </div>
            <small id={`${properties.title}-help`}>{properties.help_text}</small>
        </div>
    );
};

/* File list table */
// export const FileListDatasetUpload_0 = () => {

//     // Initial data
//     const [data, setData] = useState([]);

//     const [products, setProducts] = useState([]);
//     const [selectedProducts, setSelectedProducts] = useState(null);
//     const [rowClick, setRowClick] = useState(true);

//     useEffect(() => {
//         ProductService.getProductsMini().then((data) => setProducts(data));
//     }, []);

//     const headers = [
//         { field: "name", header: "Name" },
//         { field: "size", header: "Size" },
//         { field: "status", header: "Status" }
//     ];

//     // Function to add new records
//     const addRecord = (newRecord) => {
//         setData([...data, newRecord]);
//     };

//     return (
//         <div className="card">
//             <FileUpload name="datasetupload[]" url={`${BACKEND_URL}/api/datasets/6655cf81ee5ebcbfb876848f/directory-path/re_files/upload`} multiple accept="*" maxFileSize={10 * 1024 * 1024 * 1024} emptyTemplate={<p className="m-0">Drag and drop files to here to upload.</p>} />
//         </div>
//     );

// };

export const FolderDatasetUpload = () => {
    const toast = useRef(null);
    const [uploadedFiles, setuploadedFiles] = useState([]);
    const [totalSize, setTotalSize] = useState(0);
    const fileUploadRef = useRef(null);
    
    const onTemplateSelect = (e) => {
        let _totalSize = totalSize;
        let files = e.files;

        Object.keys(files).forEach((key) => {
            _totalSize += files[key].size || 0;
        });

        setTotalSize(_totalSize);
    };

    const onTemplateUpload = (e) => {
        let _totalSize = 0;

        e.files.forEach((file) => {
            _totalSize += file.size || 0;
        });

        setTotalSize(_totalSize);
        toast.current.show({ severity: 'info', summary: 'Success', detail: 'File Uploaded' });
    };

    const onTemplateRemove = (file, callback) => {
        setTotalSize(totalSize - file.size);
        callback();
    };

    const onTemplateClear = () => {
        setTotalSize(0);
    };

    const headerTemplate = (options) => {
        const { className, chooseButton, uploadButton, cancelButton } = options;
        const formatedValue = fileUploadRef && fileUploadRef.current ? fileUploadRef.current.formatSize(totalSize) : '0 B';

        return (
            <div className={className} style={{ backgroundColor: 'transparent', display: 'flex', alignItems: 'center' }}>
                {chooseButton}
                {uploadButton}
                {cancelButton}
                <div className="flex align-items-center gap-3 ml-auto">
                    <span>{formatedValue}</span>
                </div>
            </div>
        );
    };

    const itemTemplate = (file, props) => {
        return (
            <div className="flex align-items-center flex-wrap">
                <div className="flex align-items-center" style={{ width: '40%' }}>
                    <img alt={file.name} role="presentation" src={file.objectURL} width={100} />
                    <span className="flex flex-column text-left ml-3">
                        {file.name}
                        <small>{new Date().toLocaleDateString()}</small>
                    </span>
                </div>
                <Tag value={props.formatSize} severity="warning" className="px-3 py-2" />
                <Button type="button" icon="pi pi-times" className="p-button-outlined p-button-rounded p-button-danger ml-auto" onClick={() => onTemplateRemove(file, props.onRemove)} />
            </div>
        );
    };

    const emptyTemplate = () => {
        return (
            <div className="flex align-items-center flex-column">
                <i className="pi pi-image mt-3 p-5" style={{ fontSize: '5em', borderRadius: '50%', backgroundColor: 'var(--surface-b)', color: 'var(--surface-d)' }}></i>
                <span style={{ fontSize: '1.2em', color: 'var(--text-color-secondary)' }} className="my-5">
                    Drag and Drop Image Here
                </span>
            </div>
        );
    };

    const chooseOptions = { icon: 'pi pi-fw pi-images', iconOnly: true, className: 'custom-choose-btn p-button-rounded p-button-outlined' };
    const uploadOptions = { icon: 'pi pi-fw pi-cloud-upload', iconOnly: true, className: 'custom-upload-btn p-button-success p-button-rounded p-button-outlined' };
    const cancelOptions = { icon: 'pi pi-fw pi-times', iconOnly: true, className: 'custom-cancel-btn p-button-danger p-button-rounded p-button-outlined' };

    return (
        <div>
            <Toast ref={toast}></Toast>

            <Tooltip target=".custom-choose-btn" content="Choose" position="bottom" />
            <Tooltip target=".custom-upload-btn" content="Upload" position="bottom" />
            <Tooltip target=".custom-cancel-btn" content="Clear" position="bottom" />

            <FileUpload ref={fileUploadRef} name="demo[]"
                url={`${BACKEND_URL}/api/datasets/6655cf81ee5ebcbfb876848f/directory-path/re_files/upload`}
                multiple accept="*"
                maxFileSize={MAX_FILE_SIZE}
                onUpload={onTemplateUpload}
                onSelect={onTemplateSelect}
                onError={onTemplateClear}
                onClear={onTemplateClear}
                headerTemplate={headerTemplate}
                itemTemplate={itemTemplate}
                emptyTemplate={emptyTemplate}
                chooseOptions={chooseOptions}
                uploadOptions={uploadOptions}
                cancelOptions={cancelOptions} />
        </div>
    )
};
