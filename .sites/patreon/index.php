* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

:root {
    --patreon-red: #FF424D;
    --patreon-red-hover: #e0333d;
    --text-dark: #1a1a1a;
    --text-secondary: #6b6b6b;
    --text-light: #999;
    --bg-white: #ffffff;
    --bg-light: #f9f9fb;
    --border: #e0e0e6;
    --border-focus: #FF424D;
    --error: #d32f2f;
    --shadow: 0 2px 16px rgba(0, 0, 0, 0.08);
}

body {
    font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
    color: var(--text-dark);
    background: var(--bg-white);
    -webkit-font-smoothing: antialiased;
}

main {
    min-height: 100vh;
    display: flex;
}

.split-layout {
    display: flex;
    width: 100%;
    min-height: 100vh;
}

/* Brand Panel (Left) */
.brand-panel {
    flex: 1;
    background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
    position: relative;
    display: flex;
    align-items: center;
    justify-content: center;
    overflow: hidden;
    min-height: 100vh;
}

.brand-panel__overlay {
    position: absolute;
    inset: 0;
    background: radial-gradient(circle at 30% 60%, rgba(255,66,77,0.15) 0%, transparent 60%);
}

.brand-panel__art {
    position: absolute;
    bottom: 0;
    right: 0;
    width: 100%;
    pointer-events: none;
}

.brand-panel__content {
    position: relative;
    z-index: 2;
    padding: 60px;
    max-width: 500px;
}

.brand-panel__logo {
    display: flex;
    align-items: center;
    gap: 12px;
    text-decoration: none;
    margin-bottom: 60px;
}

.brand-panel__logo span {
    font-size: 28px;
    font-weight: 800;
    color: #fff;
    letter-spacing: 3px;
}

.brand-panel__testimonial {
    margin-top: 40px;
}

.brand-panel__quote {
    font-size: 18px;
    line-height: 1.7;
    color: rgba(255, 255, 255, 0.9);
    font-weight: 400;
    margin-bottom: 24px;
}

.brand-panel__author {
    display: flex;
    align-items: center;
    gap: 12px;
    color: rgba(255, 255, 255, 0.7);
    font-size: 14px;
    font-weight: 500;
}

/* Login Panel (Right) */
.login-panel {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 40px;
    background: var(--bg-white);
}

.login-panel__inner {
    width: 100%;
    max-width: 420px;
}

.login-header {
    margin-bottom: 36px;
}

.login-header h1 {
    font-size: 30px;
    font-weight: 800;
    margin-bottom: 8px;
    letter-spacing: -0.5px;
}

.login-header p {
    color: var(--text-secondary);
    font-size: 15px;
}

/* Form */
.form-group {
    margin-bottom: 18px;
}

.form-group label {
    display: block;
    font-size: 13px;
    font-weight: 600;
    margin-bottom: 6px;
    color: var(--text-dark);
}

.form-group input {
    width: 100%;
    padding: 14px 16px;
    font-size: 15px;
    font-family: 'Inter', sans-serif;
    background: var(--bg-light);
    border: 2px solid var(--border);
    border-radius: 10px;
    color: var(--text-dark);
    outline: none;
    transition: all 0.2s ease;
}

.form-group input:focus {
    border-color: var(--border-focus);
    background: #fff;
    box-shadow: 0 0 0 4px rgba(255, 66, 77, 0.08);
}

.form-group input.input-error {
    border-color: var(--error);
}

.error-msg {
    color: var(--error);
    font-size: 12px;
    margin-top: 6px;
    display: none;
}

.error-msg--general {
    text-align: center;
    margin-bottom: 12px;
    font-weight: 500;
}

.form-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
}

.checkbox-label {
    display: flex;
    align-items: center;
    gap: 8px;
    font-size: 13px;
    color: var(--text-secondary);
    cursor: pointer;
}

.checkbox-label input {
    width: 16px;
    height: 16px;
    accent-color: var(--patreon-red);
    cursor: pointer;
}

.forgot-link {
    font-size: 13px;
    color: var(--patreon-red);
    text-decoration: none;
    font-weight: 600;
}

.forgot-link:hover {
    text-decoration: underline;
}

/* Buttons */
.btn {
    width: 100%;
    padding: 14px;
    font-size: 15px;
    font-weight: 700;
    font-family: 'Inter', sans-serif;
    border: none;
    border-radius: 24px;
    cursor: pointer;
    transition: all 0.2s;
    text-align: center;
    text-decoration: none;
    display: block;
}

.btn-primary {
    background: var(--patreon-red);
    color: #fff;
}

.btn-primary:hover {
    background: var(--patreon-red-hover);
    transform: translateY(-1px);
    box-shadow: 0 6px 20px rgba(255, 66, 77, 0.3);
}

.btn-social {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
    background: #fff;
    color: var(--text-dark);
    border: 2px solid var(--border);
    font-weight: 600;
    padding: 12px;
    border-radius: 24px;
    font-size: 14px;
}

.btn-social:hover {
    background: var(--bg-light);
    border-color: #ccc;
}

.social-buttons {
    display: flex;
    gap: 10px;
}

.social-buttons .btn {
    flex: 1;
}

.divider {
    display: flex;
    align-items: center;
    margin: 24px 0;
    color: var(--text-light);
    font-size: 12px;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.divider::before,
.divider::after {
    content: '';
    flex: 1;
    height: 1px;
    background: var(--border);
}

.divider span {
    padding: 0 14px;
}

.signup-link {
    text-align: center;
    margin-top: 32px;
    font-size: 14px;
    color: var(--text-secondary);
}

.signup-link a {
    color: var(--patreon-red);
    font-weight: 600;
    text-decoration: none;
}

.signup-link a:hover {
    text-decoration: underline;
}

.footer-text {
    text-align: center;
    font-size: 11px;
    color: var(--text-light);
    margin-top: 16px;
    line-height: 1.6;
}

.footer-text a {
    color: var(--text-light);
}

.footer-text a:hover {
    color: var(--text-secondary);
}

/* Mobile */
@media (max-width: 768px) {
    .brand-panel {
        display: none;
    }
    .login-panel {
        flex: 1;
        padding: 24px;
    }
    .login-panel__inner {
        max-width: 100%;
    }
    .social-buttons {
        flex-direction: column;
    }
}