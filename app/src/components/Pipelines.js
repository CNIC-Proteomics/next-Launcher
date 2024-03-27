// src/components/PipelineList.js


import React from 'react';
import {
  MDBIcon,
  MDBDataTable,
} from 'mdbreact';

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
        <button type="button" className="btn btn-outline-primary btn-sm m-0 waves-effect mr-3 ">Launch</button>, 
      ]
    return {
        icon: icon,
        title: data.title,
        description: data.description,
        url: data.url,
        action: action }
  }

  const [datatable, setDatatable] = React.useState({
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
      scrollY
      maxHeight="200px"
      small
      paging={false}
      sortable={false}
      searchBottom={false}
      noHeader={true}
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
