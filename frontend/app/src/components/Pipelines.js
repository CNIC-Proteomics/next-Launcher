import React, { useState, useEffect  } from 'react';
import { DataTable } from 'primereact/datatable';
import { Column } from 'primereact/column';
import { Button } from 'primereact/button';
import { Link, useHistory } from 'react-router-dom';
import { workflowServices } from '../services/workflowServices';



// Function to import JSON files dynamically
const importAll = (r) => {
  let pipelines = [];
  r.keys().forEach(key => {
    pipelines.push(r(key));
  });
  return pipelines;
}

// Import all JSON files from the "pipelines" folder
const pipelineFiles = importAll(require.context('../../public/pipelines', false, /\.json$/));

// Lunch Button that redirect to "Parameters"
const LunchButton = ({ data, launchPipeline }) => {
  const history = useHistory();
  const [navigate, setNavigate] = useState(false);
  const [workflowId, setWorkflowId] = useState({});

  useEffect(() => {
    if (navigate) {
      console.log("PASA");
      history.push({
        pathname: '/parameters',
        state: { schema: data, workflowId: workflowId }
      });
    }
  }, [navigate, history, data, workflowId]);

  return (
    <Button
      label='Launch'
      onClick={() => launchPipeline(data, setNavigate, setWorkflowId)}
      raised
    />
  );
};

// Function that transform the pipeline data
const Pipelines = () => {

  // Launch the pipeline creating a workflow
  const launchPipeline = async (data, setNavigate, setWorkflowId) => {
    // convert the data pipeline to POST
    let convertDataToPOST = {};
    try {
      convertDataToPOST = {
        pipeline: data.url,
        revision: data.revision,
        profiles: 'guess',
      };
    } catch (error) {
      console.error('Error: converting data pipeline to POST request in the creation of a workflow: ', error);
    }
    // make the POST request to create a workflow
    try {
      if ( Object.keys(convertDataToPOST).length !== 0 && convertDataToPOST.constructor === Object) {
        console.log(convertDataToPOST);
        const result = await workflowServices.create(convertDataToPOST);
        console.log('Success:', result);
        setWorkflowId(result);
        setNavigate(true); // Set state to trigger navigation   
      }
    } catch (error) {
      console.error('Error: making a POST request in the creation of a workflow: ', error);
    }
  };

  // Define header
  const columns = [
    { field: 'status', header: 'Status' },
    { field: 'title', header: 'Title' },
    { field: 'description', header: 'Description' },
    { field: 'url', header: 'URL' },
    { field: 'action', header: 'Action' },
  ];

  // Transform the data pipeline for the table
  const convertDataToTable = data => ({
    id: data.$id,
    status: <StatusIcon status={data.status} />,
    title: data.title,
    description: data.description,
    url: <UrlLink url={data.url} />,
    action: <LunchButton data={data} launchPipeline={launchPipeline} />
  });

  const [datatable] = useState(pipelineFiles.map(convertDataToTable));

  return (
    <div className='table-pipelines'>
      <DataTable value={datatable} tableStyle={{ minWidth: '50rem' }}>
          {columns.map((col, i) => (
              // <Column key={i} field={col.field} header={col.header} headerStyle={{display:'none'}} />
              <Column key={i} field={col.field} header={col.header} />
          ))}
      </DataTable>
  </div>
  );
};

const StatusIcon = ({ status }) => {
  const iconClass = {
    0: 'pi pi-check-circle',
    1: 'pi pi-exclamation-triangle',
    2: 'pi pi-exclamation-triangle',
    default: 'pi pi-question-circle'
  }[status];
  const color = {
    0: 'green',
    1: 'orange',
    2: 'red',
    default: 'blue'
  }[status];

  return <i className={iconClass} style={{ color }}></i>;
};

const UrlLink = ({ url }) => (
  <div className="flex gap-1">
    <a href={url} target='_blank' rel="noopener noreferrer">{url}</a>
    <i className='pi pi-external-link' style={{ fontSize: '0.6rem' }}></i>
  </div>
);


export default Pipelines;
