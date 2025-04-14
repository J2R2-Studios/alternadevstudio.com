/**
 * Data file for stream recaps
 * 
 * This file exports stream recaps data fetched from Directus
 */

import { fetchStreamRecaps } from './utils/directus.js';

export default async function() {
  console.log('Stream recaps data file loaded');
  
  // Fetch stream recaps data
  const streamRecaps = await fetchStreamRecaps();
  
  // Log the stream recaps data
  console.log('Stream recaps array length:', streamRecaps.length);
  
  // Return the stream recaps data
  return streamRecaps;
}
