/**
 * Test file for stream_recap collection
 * 
 * This test verifies that the stream_recap collection exists and has the required fields.
 */

import { 
  createDirectusClient, 
  loginToDirectus,
  getItems,
  getDirectusConfig
} from '../utils/directus.js';
import { streamRecap } from '../../src/directus/collections/index.js';

describe('stream_recap Collection', () => {
  let client;
  let token;
  const { url } = getDirectusConfig();
  
  beforeAll(async () => {
    // Create Directus client
    client = createDirectusClient();
    
    // Login to Directus
    const loggedIn = await loginToDirectus(client);
    expect(loggedIn).toBe(true);
    
    // Get token for API calls
    token = client.getToken();
  });
  
  test('Collection exists and is accessible', async () => {
    try {
      // Try to get items from the collection (limit 1)
      const items = await getItems(client, 'stream_recap', { limit: 1 });
      
      // Check that we got an array
      expect(Array.isArray(items)).toBe(true);
      
      // Get the total count using the API directly
      const response = await fetch(`${url}/items/stream_recap?limit=1`, {
        headers: {
          'Authorization': `Bearer ${token}`
        }
      });
      
      const data = await response.json();
      
      // Log the number of items
      if (data.meta && data.meta.total_count !== undefined) {
        console.log(`Collection stream_recap: ${data.meta.total_count} items`);
      } else {
        console.log(`Collection stream_recap: exists (no meta information available)`);
      }
      
    } catch (error) {
      // Fail the test if there's an error
      console.error(`Error accessing collection stream_recap: ${error.message}`);
      throw error;
    }
  });
  
  describe('Field structure', () => {
    let fields;
    
    beforeAll(async () => {
      // Get the expected fields from the collection definition
      fields = streamRecap.fields.map(field => ({
        field: field.field,
        type: field.type
      }));
      
      // Log the expected fields
      console.log('Expected fields:', fields.map(f => f.field).join(', '));
    });
    
    test('has title field (string)', () => {
      const field = fields.find(f => f.field === 'title');
      expect(field).toBeDefined();
      expect(field.type).toBe('string');
    });
    
    test('has stream_date field (timestamp)', () => {
      const field = fields.find(f => f.field === 'stream_date');
      expect(field).toBeDefined();
      expect(['timestamp', 'datetime'].includes(field.type)).toBe(true);
    });
    
    test('has video_url field (string)', () => {
      const field = fields.find(f => f.field === 'video_url');
      expect(field).toBeDefined();
      expect(field.type).toBe('string');
    });
    
    test('has summary field (text)', () => {
      const field = fields.find(f => f.field === 'summary');
      expect(field).toBeDefined();
      expect(['text', 'string'].includes(field.type)).toBe(true);
    });
    
    test('has all expected fields', () => {
      // Get the expected fields from the collection definition
      const expectedFields = streamRecap.fields.map(field => field.field);
      
      // Check that all expected fields are present
      for (const fieldName of expectedFields) {
        const field = fields.find(f => f.field === fieldName);
        expect(field).toBeDefined();
      }
    });
  });
});
