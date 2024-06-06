import React, { useState, useEffect } from 'react';
import { Link, useLocation  } from 'react-router-dom';
// import { TabView, TabPanel } from 'primereact/tabview';
// import { TabMenu } from 'primereact/tabmenu';

const NavigationTabs = () => {
  const location = useLocation();
  const [activeIndex, setActiveIndex] = useState(0);

  const items = [{
    label: 'Main',
    icon: 'pi pi-home',
    to: '/'
  },{
    label: 'Pipelines',
    icon: 'pi pi-sitemap',
    to: '/pipelines'
  },{
    label: 'Parameters',
    icon: 'pi pi-list',
    to: '/parameters'
  }];

  useEffect(() => {
      const pathToIndex = {
          '/': 0,
          '/pipelines': 1,
          '/parameters': 2
      };
      setActiveIndex(pathToIndex[location.pathname]);
  }, [location]);

  return (
      <div className="header">
        <TabMenuWithLink items={items} activeIndex={activeIndex} onTabChange={(e) => setActiveIndex(e.index)} />
      </div>
  );
};

const TabMenuWithLink = ({ items, activeIndex, onTabChange }) => {
  return (
      <div className="p-tabmenu p-component">
          <ul className="p-tabmenu-nav p-reset" role="tablist">
              {items.map((item, index) => (
                  <li key={index} className={`p-tabmenuitem ${index === activeIndex ? 'p-highlight' : ''}`} onClick={() => onTabChange({ index })}>
                      <Link to={item.to} className="p-menuitem-link">
                          <span className={`p-menuitem-icon ${item.icon}`}></span>
                          <span className="p-menuitem-text">{item.label}</span>
                      </Link>
                  </li>
              ))}
          </ul>
      </div>
  );
};

export default NavigationTabs;
