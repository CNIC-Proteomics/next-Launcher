import React, { useState } from 'react';
import {
  MDBIcon,
  MDBCollapse,
  MDBRipple,
  MDBListGroup,
  MDBListGroupItem,
} from 'mdb-react-ui-kit';
import {
  Container,
  Row,
  Col,
  Card,
  Button,
  InputGroup,
  Form
 } from 'react-bootstrap';


// Component for rendering input properties
const Inputs = ({ properties }) => {
  return (
  <>
    {(properties.format === 'path' || properties.format === 'directory-path')&& (
      <InputGroup className="mb-3">
        <Form.Control />
        <Button variant="outline-secondary">Select folder</Button>
      </InputGroup>
          )}
    {properties.format === 'file-path' && (
      <InputGroup className="mb-3">
        <Form.Control
          placeholder="Recipient's username"
          aria-label="Recipient's username"
          aria-describedby="basic-addon2"
        />
        <Button variant="outline-secondary" id="button-addon2">Select file</Button>
      </InputGroup>
    )}
  </>
  );
};


// Component for rendering input properties
const Properties = ({ definitions }) => {
  return (
    <>
    { Object.keys(definitions).map((i) => (
      <Card
        key={i}
        className="mb-3"
        border="secondary">
        <Card.Header>
          <MDBIcon fas icon={definitions[i].fa_icon} className="me-3" />{definitions[i].title}
        </Card.Header>
        { Object.keys(definitions[i].properties).map((j) => (
          <Card.Body key={j}>
            <Inputs properties={definitions[i].properties[j]} />
          </Card.Body>
        ))}
      </Card>
    ))}
    </>
  );
};

const Sidebar = ({ definitions }) => {

  const [collapsedMenus, setCollapsedMenus] = useState({});

  const toggleSubMenu = (menuHeader) => {
    setCollapsedMenus({
      ...collapsedMenus,
      [menuHeader]: !collapsedMenus[menuHeader]
    });
  };

  return (
    <div className="parameters-sidenav">
      <div className="sidebar d-lg-block bg-white">
        <MDBListGroup className="mx-3 mt-4">

          { Object.keys(definitions).map((i) => (
            <div key={i}>
            <MDBRipple rippleTag='span'>     
              <MDBListGroupItem action className='border-0 border-bottom rounded rounded' onClick={() => toggleSubMenu(definitions[i].title)}>
                <MDBIcon fas icon={definitions[i].fa_icon} className="me-3" />
                {definitions[i].title}
                <MDBIcon icon={collapsedMenus[definitions[i].title] ? "angle-right" : "angle-down"} className="ms-3" />
              </MDBListGroupItem>
            </MDBRipple>
            <MDBCollapse open={collapsedMenus[definitions[i].title]}>
              <MDBListGroup>
              { Object.keys(definitions[i].properties).map((j) => ( <MDBListGroupItem key={j} className="py-1" tag='a' action href='#'>{definitions[i].properties[j].title}</MDBListGroupItem> ))}
              </MDBListGroup>
            </MDBCollapse>
            </div>
          ))}

        </MDBListGroup>
      </div>
    </div>
  );
};


const Parameters = (props) => {

  // Pipeline schema
  if ( props.location.schema ) {
    const schemaData = props.location.schema;
    return (
      <div className='parameters'>
      <Container fluid>
        <Row>
          <Col sm={3}>
          <Sidebar definitions={schemaData.definitions} />
          </Col>
          <Col sm={9}>
            <Properties definitions={schemaData.definitions} />
          </Col>
        </Row>
      </Container>

      </div>
    );
  
  }
  // The component has not received the pipeline schema
  else {
    return (
      <div>
        <p>The pipeline schema is required</p>
      </div>
    );
  }
};

export default Parameters;

