// src/App.js

import React from 'react';
import AppHeader from './components/AppHeader';
import AppRouter from './AppRouter';
import './App.css';

const AppDescription = () => {
  return (
    <div className='app-description'>
      Web server for the execution of Nextflow pipelines
    </div>
  );
}

function App() {
  return (
    <div className="App">
      <AppHeader />
      <AppDescription />
      <AppRouter />
    </div>
  );
}

export default App;
