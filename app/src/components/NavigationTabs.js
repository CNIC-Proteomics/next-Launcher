import React from 'react';
import { Link } from 'react-router-dom';

const NavigationTabs = () => {
  return (
    <ul className="nav nav-tabs custom-tabs">
      <li className="nav-item">
        <Link to="/pipelines" className="nav-link">Pipelines</Link>
      </li>
      <li className="nav-item">
        <Link to="/parameters" className="nav-link">Parameters</Link>
      </li>
    </ul>
  );
};

export default NavigationTabs;

