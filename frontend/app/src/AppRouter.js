import React from 'react';
import { BrowserRouter as Router, Route, Switch } from 'react-router-dom';
import NavigationTabs from './components/NavigationTabs';
import MainPage from './components/MainPage';
import Pipelines from './components/Pipelines';
import Parameters from './components/Parameters';
// import Launcher from './components/Launcher';


const AppRouter = () => {
  return (
    <Router>
      <div className='navigation-tabs'>
        <NavigationTabs />
      </div>
      <div className='app-container'>
        <Switch>
          <Route path="/" exact component={MainPage} />
          <Route path="/pipelines" component={Pipelines} />
          <Route path="/parameters" component={Parameters} />
          {/* <Route path="/launcher" component={Launcher} /> */}
        </Switch>
      </div>
    </Router>
  );
};

export default AppRouter;
