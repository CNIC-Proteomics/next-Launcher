import React from 'react';
// import { Navbar, Nav, Container } from 'react-bootstrap';
import { Menubar } from 'primereact/menubar';
import { BrowserRouter as Router } from 'react-router-dom';
import { Link } from 'react-router-dom';

const AppHeader = () => {
  const items = [
    {
      label: 'next-Launcher',
      url: '/'
    }
  ];
  const start = (
    <div className="flex align-items-center gap-2">
      <img alt="logo" src="https://primefaces.org/cdn/primereact/images/logo.png" height="40" className="mr-2"></img>
      <a href="/" className="p-menuitem-title">
        <span className="p-menuitem-text">next-Launcher</span>
      </a>
    </div>
  );

  const end = (
    <Router>
      <ul className='p-menubar-root-list'>
        <li className='p-menuitem-content'>
          <Link to="/pipelines" className="p-menuitem">Pipelines</Link>
        </li>
        <li className='p-menuitem-content'>
          <Link to="/workflows" className="p-menuitem">Workflows</Link>
        </li>
        <li className='p-menuitem-content'>
          <Link to="/datasets" className="p-menuitem">Datasets</Link>
        </li>
      </ul>
    </Router>
  );

  return (
    <div className='app-header-container'>
      <Menubar start={start} end={end} />
    </div>
  )

};

export default AppHeader;