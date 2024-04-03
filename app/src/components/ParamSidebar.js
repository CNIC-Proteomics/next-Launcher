import React from 'react';
import { Nav, Accordion, Card } from 'react-bootstrap';

const ParamSidebar = ({ schema }) => {

  // Function to render submenus
  const renderSubmenus = (properties) => {
    if (!properties || typeof properties !== 'object') {
        return null; // Return null if properties is not valid
    }
    return Object.keys(properties).map((key) => (
      <Accordion key={key}>
        <Card>
          <Accordion.Toggle as={Card.Header} eventKey={key}>
            {properties[key].title}
          </Accordion.Toggle>
          <Accordion.Collapse eventKey={key}>
            <Card.Body>
              {/* Render submenu items */}
              {Object.keys(properties[key]).map((itemKey) => (
                <Nav.Item key={itemKey}>
                  <Nav.Link href="#">{properties[key][itemKey].description}</Nav.Link>
                </Nav.Item>
              ))}
            </Card.Body>
          </Accordion.Collapse>
        </Card>
      </Accordion>
    ));
  };

  // Function to render main menu items
  const renderMainMenu = () => {
    if (!schema || typeof schema !== 'object') {
        return null; // Return null if jsonData is not valid
    }
    return Object.keys(schema.definitions).map((menu) => (
      <Nav.Item key={menu}>
        <Accordion defaultActiveKey="0">
          <Card>
            <Accordion.Toggle as={Card.Header} eventKey="0">
              {schema.definitions[menu].title}
            </Accordion.Toggle>
            <Accordion.Collapse eventKey="0">
              <Card.Body>
                {/* Render submenus */}
                {/* {renderSubmenus(schema.definitions[menu].properties)} */}
              </Card.Body>
            </Accordion.Collapse>
          </Card>
        </Accordion>
      </Nav.Item>
    ));
  };

  return (
    <div>
    <Nav className="flex-column">
        {/* Render submenus */}
        {renderMainMenu()}
    </Nav>
    </div>
  );
};

export default ParamSidebar;
