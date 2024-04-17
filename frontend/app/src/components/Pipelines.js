import React, { useState } from 'react';
import {
  MDBIcon,
  MDBDataTable,
} from 'mdbreact';
import { Link } from 'react-router-dom';

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



const Pipelines = () => {
  const transform = data => {
    let icon
    switch (data.id) {
        case 0:
            icon = <MDBIcon id={data.id}  icon="times-circle" size="2x" className="red-text pr-3" />
            break;
        case 1:
            icon = <MDBIcon id={data.id}  icon="check-circle" size="2x" className="green-text pr-3" />
            break;    
        case 2:
            icon = <MDBIcon id={data.id}  icon="fas fa-ban" size="2x" className="red-text pr-3" />
            break;    
        default:
          icon = <MDBIcon id={data.id}  icon="check-circle" size="2x" className="green-text pr-3" />
            break;
    }
    const action = [
        <Link to={{
          pathname: '/parameters',
          schema: data,
        }}>
          <button type="button" className="btn btn-outline-primary btn-sm m-0 mr-3 ">Launch</button>
        </Link>,
      ]
    return {
        icon: icon,
        title: data.title,
        description: data.description,
        url: data.url,
        action: action }
  }

  const [datatable] = useState({
    columns: [
      {
        label: '',
        field: 'icon',
        // width: 10,
      },
      {
        label: '',
        field: 'title',
        // width: 150,
      },
      {
        label: '',
        field: 'description',
        // width: 270,
      },
      {
        label: '',
        field: 'url',
        // width: 200,
      },
      {
        label: '',
        field: 'action',
        // width: 10,
      },
    ],
    rows: pipelineFiles.map(transform),
  });

  return (
    <div className="table-pipelines">
    <MDBDataTable
      key='0'
      scrollY
      maxHeight="200px"
      small
      paging={false}
      sortable={false}
      data={datatable}
    />
  </div>
  );


//   <MDBDataTable
//   scrollY
//   maxHeight="200px"
//   small
//   paging={false}
//   sortable={false}
//   searchBottom={false}
//   noHeader={true}
//   data={datatable}
// />

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
