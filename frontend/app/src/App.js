// src/App.js

import React from 'react';
// import AppToaster from './services/toastServices';
import { Toast } from 'primereact/toast';
import { toastRef } from './services/toastServices';
import AppHeader from './components/AppHeader';
import AppRouter from './AppRouter';


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
      {/* <AppToaster /> */}
      <Toast ref={toastRef} />
      <AppHeader />
      <AppDescription />
      <AppRouter />
    </div>
  );
}

export default App;
