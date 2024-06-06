import { createRef } from 'react';
import { Toast } from 'primereact/toast';

// Create a ref for the Toast component
const toastRef = createRef();

// Function to display a toast message
const showToast = (severity, summary, detail) => {
  toastRef.current.show({ severity, summary, detail, life: 3000 });
};

// Wrapper functions for different types of messages
const showInfo = (summary, detail) => showToast('info', summary, detail);
const showError = (summary, detail) => showToast('error', summary, detail);
const showWarning = (summary, detail) => showToast('warn', summary, detail);

// const AppToaster = () => {
//     return (<Toast ref={toastRef} />);
// };

// Export the ref and the functions
export { toastRef, showInfo, showError, showWarning };
// export default AppToaster;