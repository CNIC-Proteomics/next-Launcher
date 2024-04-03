import React from 'react';
import { BrowserRouter as Router, Route, Switch, Redirect } from 'react-router-dom';
import NavigationTabs from './components/NavigationTabs';
// import MainPage from './components/MainPage';
import Pipelines from './components/Pipelines';
import Parameters from './components/Parameters';

const AppRouter = () => {
  return (
    <Router>
      <div className='navigation-tabs'>
        <NavigationTabs />
      </div>
      <div className='app-container'>
        <Switch>
          {/* <Route path="/" exact component={MainPage} /> */}
          <Route exact path="/">
            <Redirect to="/pipelines" />
          </Route>
          <Route path="/pipelines" component={Pipelines} />
          <Route path="/parameters" component={Parameters} />
        </Switch>
      </div>
    </Router>
  );
};

export default AppRouter;
