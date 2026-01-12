package com.example.helloworld;

import android.os.Bundle;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.app.AppCompatDelegate;

/**
 * Main Activity for the Hello World Android Application.
 * 
 * This application demonstrates a basic Android setup with:
 * - Eclipse Temurin JDK 17 via Gradle toolchain
 * - Automatic Android SDK provisioning
 * - Material Design 3 theming
 * - View Binding for type-safe view access
 */
public class MainActivity extends AppCompatActivity {
    
    private TextView textHelloWorld;
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        // Enable day/night theme support
        AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_FOLLOW_SYSTEM);
        
        // Set content view using view binding
        setContentView(R.layout.activity_main);
        
        // Initialize views
        initializeViews();
        
        // Display environment verification message
        displayWelcomeMessage();
    }
    
    /**
     * Initialize view references using findViewById
     */
    private void initializeViews() {
        textHelloWorld = findViewById(R.id.text_hello);
    }
    
    /**
     * Display a welcome message with environment verification
     */
    private void displayWelcomeMessage() {
        String message = "Hello World!\n\n" +
                         "Environment Verified:\n" +
                         "• Gradle 8.5\n" +
                         "• Eclipse Temurin JDK 17\n" +
                         "• Android SDK 34\n" +
                         "• Build Tools 34.0.0";
        
        textHelloWorld.setText(message);
    }
    
    /**
     * Lifecycle method - called when activity becomes visible
     */
    @Override
    protected void onStart() {
        super.onStart();
        // Activity is starting
    }
    
    /**
     * Lifecycle method - called when activity becomes interactive
     */
    @Override
    protected void onResume() {
        super.onResume();
        // Activity is in foreground
    }
    
    /**
     * Lifecycle method - called when activity is no longer in foreground
     */
    @Override
    protected void onPause() {
        super.onPause();
        // Activity is partially obscured
    }
    
    /**
     * Lifecycle method - called when activity is no longer visible
     */
    @Override
    protected void onStop() {
        super.onStop();
        // Activity is no longer visible
    }
    
    /**
     * Lifecycle method - called before activity is destroyed
     */
    @Override
    protected void onDestroy() {
        super.onDestroy();
        // Clean up resources
    }
}
