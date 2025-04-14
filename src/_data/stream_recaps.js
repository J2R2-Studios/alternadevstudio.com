/**
 * Data file for stream recaps
 * 
 * This file exports the stream recaps data from the directus.js file
 */

import directusData from './utils/directus.js';

export default async function() {
  console.log('Stream recaps data file loaded');
  
  // Get the data from directus.js
  const data = await directusData();
  
  // Log the stream recaps data
  console.log('Stream recaps data:', data.stream_recaps);
  console.log('Stream recaps array length:', data.stream_recaps.length);
  
  // Return the stream recaps data
  return data.stream_recaps;
}
