package io.andreealavric.fingerfy;

import android.accessibilityservice.AccessibilityService;
import android.view.accessibility.AccessibilityEvent;
import android.util.Log;

public class GlobalTouchService extends AccessibilityService {
    private static final String TAG = "GlobalTouchService";
    private int globalTouchCount = 0;
    private int globalScrollCount = 0;

    @Override
    public void onAccessibilityEvent(AccessibilityEvent event) {
        switch (event.getEventType()) {
            case AccessibilityEvent.TYPE_VIEW_CLICKED:
                globalTouchCount++;
                Log.d(TAG, "Touch Count: " + globalTouchCount);
                break;
            case AccessibilityEvent.TYPE_VIEW_SCROLLED:
                globalScrollCount++;
                Log.d(TAG, "Scroll Count: " + globalScrollCount);
                break;
        }
    }

    @Override
    public void onInterrupt() {
        // Gestisci l'interruzione del servizio
    }
}
