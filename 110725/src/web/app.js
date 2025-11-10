// API endpoint - relative URL (proxied by Apache)
const API_URL = '/api';

// Check if we're on the login page or pictures page
if (window.location.pathname.includes('pictures.html')) {
    // Pictures page logic
    loadPictures();
    setupPicturePageHandlers();
} else {
    // Login page logic
    setupLoginHandler();
}

function setupLoginHandler() {
    const loginForm = document.getElementById('loginForm');
    const errorMessage = document.getElementById('error-message');

    loginForm.addEventListener('submit', async (e) => {
        e.preventDefault();
        errorMessage.textContent = '';

        const username = document.getElementById('username').value;
        const password = document.getElementById('password').value;

        try {
            const response = await fetch(`${API_URL}/api/login`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ username, password })
            });

            const data = await response.json();

            if (response.ok && data.success) {
                // Store authentication (in production, use proper session management)
                sessionStorage.setItem('authenticated', 'true');
                sessionStorage.setItem('username', username);
                window.location.href = 'pictures.html';
            } else {
                errorMessage.textContent = data.message || 'Invalid username or password';
            }
        } catch (error) {
            console.error('Login error:', error);
            errorMessage.textContent = 'Unable to connect to server. Please try again.';
        }
    });
}

async function loadPictures() {
    // Check if user is authenticated
    if (!sessionStorage.getItem('authenticated')) {
        window.location.href = 'index.html';
        return;
    }

    const pictureSelect = document.getElementById('pictureSelect');
    const errorMessage = document.getElementById('error-message');

    try {
        const response = await fetch(`${API_URL}/api/pictures`);
        const data = await response.json();

        if (response.ok && data.success) {
            pictureSelect.innerHTML = '<option value="">-- Select a picture --</option>';
            
            data.pictures.forEach(picture => {
                const option = document.createElement('option');
                option.value = picture.url;
                option.textContent = picture.name;
                pictureSelect.appendChild(option);
            });
        } else {
            errorMessage.textContent = 'Failed to load pictures';
        }
    } catch (error) {
        console.error('Error loading pictures:', error);
        errorMessage.textContent = 'Unable to connect to server';
    }
}

function setupPicturePageHandlers() {
    const pictureSelect = document.getElementById('pictureSelect');
    const viewButton = document.getElementById('viewButton');
    const logoutButton = document.getElementById('logoutButton');

    pictureSelect.addEventListener('change', () => {
        viewButton.disabled = !pictureSelect.value;
    });

    viewButton.addEventListener('click', () => {
        const url = pictureSelect.value;
        if (url) {
            window.open(url, '_blank');
        }
    });

    logoutButton.addEventListener('click', () => {
        sessionStorage.clear();
        window.location.href = 'index.html';
    });
}