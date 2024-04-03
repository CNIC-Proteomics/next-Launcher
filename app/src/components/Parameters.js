import React from 'react';
import { Form, Button } from 'react-bootstrap';
import ParamSidebar from './ParamSidebar';


const Parameters = (props) => {

  const handleChange = (event, key) => {
    const value = event.target.value;
    // setFormData({ ...formData, [key]: value });
  };

  const handleSubmit = (event) => {
    event.preventDefault();
    // Handle form submission
    // console.log(formData);
  };
  
  // Check if myVar is defined
  if (typeof props.location.state !== 'undefined') {
    const { schema } = props.location.state;

    return (
      <div>
        <Form>
        <h2>{schema.title}</h2>
        </Form>
        <ParamSidebar schema={schema}/> 
      </div>
    );
    // return (
    //   <Form onSubmit={handleSubmit}>
    //     <h2>{schema.title}</h2>
    //     {Object.entries(schema.properties).map(([key, value]) => (
    //       <Form.Group key={key}>
    //         <Form.Label>{value.description}</Form.Label>
    //         {value.format === 'file-path' ? (
    //           <Form.Control
    //             type="file"
    //             // onChange={(e) => handleChange(e, key)}
    //             multiple={value.multiple}
    //           />
    //         ) : (
    //           <Form.Control
    //             type="text"
    //             defaultValue={value.default}
    //             // onChange={(e) => handleChange(e, key)}
    //           />
    //         )}
    //         {value.help_text && <Form.Text>{value.help_text}</Form.Text>}
    //       </Form.Group>
    //     ))}
    //     <Button variant="primary" type="submit">
    //       Submit
    //     </Button>
    //   </Form>
    // );
  } else {
    return <div>myVar is not defined</div>;
  }

  

};

export default Parameters;





