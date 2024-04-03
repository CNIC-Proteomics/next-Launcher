// src/components/PipelineList.js
import React from 'react';
import {
  MDBIcon,
  MDBDataTable,
} from 'mdbreact';
import { Link } from 'react-router-dom';
import { Button } from 'react-bootstrap';

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

// Create dynamically the Pipeline list
const Pipelines = () => {
  const transform = schema => {
    let icon
    switch (schema.id) {
        case 0:
            icon = <MDBIcon id={schema.id}  icon="times-circle" size="2x" className="red-text pr-3" />
            break;
        case 1:
            icon = <MDBIcon id={schema.id}  icon="check-circle" size="2x" className="green-text pr-3" />
            break;    
        case 2:
            icon = <MDBIcon id={schema.id}  icon="fas fa-ban" size="2x" className="red-text pr-3" />
            break;    
        default:
          icon = <MDBIcon id={schema.id}  icon="check-circle" size="2x" className="green-text pr-3" />
            break;
    }
    const action = [
        // <Link to={{ pathname: '/parameters', state: { schema: schema } }} type="button" className="btn btn-outline-primary btn-sm m-0 waves-effect mr-3">Create workflow</Link>
        <Link to={{ pathname: '/parameters', state: { schema: schema } }}>
          <Button variant="outline-primary" className="highlight-on-hover">Create workflow</Button>
        </Link>
      ]
    return {
        icon: icon,
        title: schema.title,
        description: schema.description,
        url: schema.url,
        action: action }
  }

  const [datatable] = React.useState({
    columns: [
      {
        label: '',
        field: 'icon',
      },
      {
        label: '',
        field: 'title',
      },
      {
        label: '',
        field: 'description',
      },
      {
        label: '',
        field: 'url',
      },
      {
        label: '',
        field: 'action',
      },
    ],
    rows: pipelineFiles.map(transform),
  });

  return (
    <div className="table-pipelines">
    <MDBDataTable
      scrollY
      maxHeight="200px"
      small
      paging={false}
      sortable={false}
      // searchBottom={false}
      // noHeader={true}
      data={datatable}
    />
  </div>
  );
//   <MDBDataTableV5
//   hover
//   data={datatable}
//   searchTop
//   barReverse
//   materialSearch
//   paging={false}
//   sortable={false}
//   searchBottom={false}
//   style={{ width: '50%' }} // Set the width of the DataTable here
// />

  // return (
  //   <MDBDataTableV5
  //     hover
  //     striped
  //     entriesOptions={[5, 20, 25]}
  //     entries={5}
  //     pagesAmount={4}
  //     data={datatable}
  //     searchTop
  //     searchBottom={false}
  //   />
  // );  
}

export default Pipelines;
