/*
 * Workflow Services
 */


/*
 * Import libraries/constants
 */

import {
  BACKEND_URL, 
  MAX_FILE_SIZE
} from '../constants';



/*
 * Define class
 */

export class workflowServices {


  // create a workflow based on a pipeline
  static async create(data) {
    try {
      const response = await fetch(`${BACKEND_URL}/api/workflows/0`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(data),
      });

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const result = await response.json();
      return result;
    } catch (error) {
      console.error('Error:', error);
      throw error;
    }
  }


};
  