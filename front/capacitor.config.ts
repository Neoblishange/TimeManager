import { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.frontv2',
  appName: 'frontv2',
  webDir: 'dist',
  server: {
    androidScheme: 'https'
  }
};

export default config;
