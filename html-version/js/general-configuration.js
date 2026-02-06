// General Configuration JavaScript functionality

document.addEventListener('DOMContentLoaded', function() {
    // Initialize interactive elements
    initializeSearchableDropdown();
    initializeNavigation();
    initializeNotifications();
    initializeToggleSwitches();
    initializeEditButtons();
    initializeActionMenus();
    initializeEditModal();
});

// Navigation functionality
function initializeNavigation() {
    const menuBtn = document.querySelector('.nav-menu-btn');
    const profileBtn = document.querySelector('.profile-btn');
    const navDrawer = document.getElementById('navDrawer');
    const drawerOverlay = document.getElementById('drawerOverlay');
    
    // Open navigation drawer
    if (menuBtn) {
        menuBtn.addEventListener('click', () => {
            navDrawer.classList.add('open');
            drawerOverlay.classList.add('active');
            document.body.style.overflow = 'hidden'; // Prevent background scrolling
        });
    }
    
    // Close on overlay click
    if (drawerOverlay) {
        drawerOverlay.addEventListener('click', closeDrawer);
    }
    
    // Close on escape key
    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape' && navDrawer.classList.contains('open')) {
            closeDrawer();
        }
    });
    
    // Handle drawer items
    const drawerItems = document.querySelectorAll('.drawer-item');
    drawerItems.forEach(item => {
        item.addEventListener('click', () => {
            const page = item.getAttribute('data-page');
            
            // Remove active class from all items
            document.querySelectorAll('.drawer-item').forEach(drawerItem => {
                drawerItem.classList.remove('active');
            });
            
            // Add active class to clicked item
            item.classList.add('active');
            
            // Close drawer after selection
            closeDrawer();
            
            // Navigate to page if it has a data-page attribute
            if (page) {
                navigateToPage(page);
            }
            
            console.log('Navigation clicked:', item.querySelector('.drawer-text').textContent);
        });
    });
    
    // Navigation function
    function navigateToPage(page) {
        switch(page) {
            case 'control-panel':
                window.location.href = 'control-panel.html';
                break;
            case 'monitor':
                window.location.href = 'monitor.html';
                break;
            case 'security':
                window.location.href = 'security.html';
                break;
            case 'approval-module':
                window.location.href = 'approval-module.html';
                break;
            case 'general-configuration':
                window.location.href = 'general-configuration.html';
                break;
            default:
                console.log('Page not implemented yet:', page);
        }
    }
    
    if (profileBtn) {
        profileBtn.addEventListener('click', (e) => {
            e.stopPropagation();
            toggleProfileDropdown();
        });
    }
    
    // Close profile dropdown when clicking outside
    document.addEventListener('click', (e) => {
        const profileDropdown = document.getElementById('profileDropdown');
        if (profileDropdown && !profileDropdown.contains(e.target) && !profileBtn.contains(e.target)) {
            closeProfileDropdown();
        }
    });

    document.querySelectorAll('.profile-option').forEach(option => {
        option.addEventListener('click', () => {
            const action = option.getAttribute('data-action');
            closeProfileDropdown();
            if (action === 'account-settings') window.location.href = 'account-settings.html';
            else if (action === 'invitations') window.location.href = 'invitation.html';
            else if (action === 'logout') showLogoutDialog();
        });
    });
}

function closeDrawer() {
    const navDrawer = document.getElementById('navDrawer');
    const drawerOverlay = document.getElementById('drawerOverlay');
    
    navDrawer.classList.remove('open');
    drawerOverlay.classList.remove('active');
    document.body.style.overflow = 'auto';
}

function toggleProfileDropdown() {
    const profileDropdown = document.getElementById('profileDropdown');
    if (profileDropdown) {
        if (profileDropdown.classList.contains('show')) {
            closeProfileDropdown();
        } else {
            openProfileDropdown();
        }
    }
}

function openProfileDropdown() {
    const profileDropdown = document.getElementById('profileDropdown');
    if (profileDropdown) {
        profileDropdown.classList.add('show');
    }
}

function closeProfileDropdown() {
    const profileDropdown = document.getElementById('profileDropdown');
    if (profileDropdown) {
        profileDropdown.classList.remove('show');
    }
}

// Searchable Dropdown functionality
function initializeSearchableDropdown() {
    const dropdown = document.getElementById('searchableDropdown');
    const trigger = document.getElementById('dropdownTrigger');
    const menu = document.getElementById('dropdownMenu');
    const searchInput = document.getElementById('searchInput');
    const selectedText = document.getElementById('selectedText');
    const options = document.querySelectorAll('.dropdown-option');
    
    let isOpen = false;
    
    // Toggle dropdown
    trigger.addEventListener('click', (e) => {
        e.stopPropagation();
        toggleDropdown();
    });
    
    // Close dropdown when clicking outside
    document.addEventListener('click', (e) => {
        if (!dropdown.contains(e.target)) {
            closeDropdown();
        }
    });
    
    // Handle search input
    searchInput.addEventListener('input', (e) => {
        const searchTerm = e.target.value.toLowerCase();
        filterOptions(searchTerm);
    });
    
    // Handle option selection
    options.forEach(option => {
        option.addEventListener('click', (e) => {
            e.preventDefault();
            const value = option.getAttribute('data-value');
            const text = option.querySelector('.option-text').textContent;
            
            updateSelectedOption(value, text);
            closeDropdown();
            
            // Update provider data
            updateProviderData(value, text);
        });
    });
    
    // Close dropdown on escape key
    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape' && isOpen) {
            closeDropdown();
        }
    });
    
    function toggleDropdown() {
        if (isOpen) {
            closeDropdown();
        } else {
            openDropdown();
        }
    }
    
    function openDropdown() {
        menu.classList.add('show');
        trigger.classList.add('active');
        searchInput.focus();
        isOpen = true;
    }
    
    function closeDropdown() {
        menu.classList.remove('show');
        trigger.classList.remove('active');
        isOpen = false;
    }
    
    function filterOptions(searchTerm) {
        options.forEach(option => {
            const text = option.querySelector('.option-text').textContent.toLowerCase();
            if (text.includes(searchTerm)) {
                option.classList.remove('hidden');
            } else {
                option.classList.add('hidden');
            }
        });
    }
    
    function showAllOptions() {
        options.forEach(option => {
            option.classList.remove('hidden');
        });
    }
    
    function updateSelectedOption(value, text) {
        // Remove previous selection
        options.forEach(option => {
            option.classList.remove('selected');
            option.setAttribute('data-selected', 'false');
        });
        
        // Add selection to new option
        const selectedOption = document.querySelector(`[data-value="${value}"]`);
        if (selectedOption) {
            selectedOption.classList.add('selected');
            selectedOption.setAttribute('data-selected', 'true');
        }
        
        // Update display text
        selectedText.textContent = text;
    }
}

// Update Provider Data (placeholder function)
function updateProviderData(provider, providerText) {
    // This function would typically:
    // 1. Make API calls to fetch new data for the selected provider
    // 2. Update the configuration data
    // 3. Update any other data on the page
    
    console.log('Updating provider data for:', providerText);
    
    // Show loading state
    showLoading();
    
    // Simulate API call
    setTimeout(() => {
        hideLoading();
        showSuccess('Configuration updated for ' + providerText);
        
        // Example of how you might update the configuration data
        // updateConfigurationData(newData);
    }, 1000);
}

// Notifications functionality
function initializeNotifications() {
    const notificationBtn = document.getElementById('notificationBtn');
    const notificationsDropdown = document.getElementById('notificationsDropdown');
    const markAllReadBtn = document.getElementById('markAllReadBtn');
    const notificationBadge = document.getElementById('notificationBadge');
    
    // Toggle notifications dropdown
    if (notificationBtn) {
        notificationBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            toggleNotificationsDropdown();
        });
    }
    
    // Close dropdown when clicking outside
    document.addEventListener('click', function(e) {
        if (!notificationBtn.contains(e.target) && !notificationsDropdown.contains(e.target)) {
            closeNotificationsDropdown();
        }
    });
    
    // Mark all as read
    if (markAllReadBtn) {
        markAllReadBtn.addEventListener('click', function() {
            markAllNotificationsAsRead();
        });
    }
    
    // Handle individual notification close buttons
    const closeButtons = document.querySelectorAll('.notification-close');
    closeButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            e.stopPropagation();
            const notificationId = this.getAttribute('data-id');
            removeNotification(notificationId);
        });
    });
    
    // Handle notification item clicks
    const notificationItems = document.querySelectorAll('.notification-item');
    notificationItems.forEach(item => {
        item.addEventListener('click', function() {
            const notificationId = this.getAttribute('data-id');
            markNotificationAsRead(notificationId);
        });
    });
}

function toggleNotificationsDropdown() {
    const notificationsDropdown = document.getElementById('notificationsDropdown');
    if (notificationsDropdown) {
        if (notificationsDropdown.classList.contains('show')) {
            closeNotificationsDropdown();
        } else {
            openNotificationsDropdown();
        }
    }
}

function openNotificationsDropdown() {
    const notificationsDropdown = document.getElementById('notificationsDropdown');
    if (notificationsDropdown) {
        notificationsDropdown.classList.add('show');
    }
}

function closeNotificationsDropdown() {
    const notificationsDropdown = document.getElementById('notificationsDropdown');
    if (notificationsDropdown) {
        notificationsDropdown.classList.remove('show');
    }
}

function markAllNotificationsAsRead() {
    const unreadNotifications = document.querySelectorAll('.notification-item.unread');
    const notificationBadge = document.getElementById('notificationBadge');
    
    unreadNotifications.forEach(notification => {
        notification.classList.remove('unread');
    });
    
    // Update badge count
    updateNotificationBadge();
    
    // Show success message
    showSuccess('All notifications marked as read');
}

function markNotificationAsRead(notificationId) {
    const notification = document.querySelector(`.notification-item[data-id="${notificationId}"]`);
    if (notification && notification.classList.contains('unread')) {
        notification.classList.remove('unread');
        updateNotificationBadge();
    }
}

function removeNotification(notificationId) {
    const notification = document.querySelector(`.notification-item[data-id="${notificationId}"]`);
    if (notification) {
        // Check if it was unread before removing
        const wasUnread = notification.classList.contains('unread');
        
        // Remove the notification
        notification.remove();
        
        // Update badge count if it was unread
        if (wasUnread) {
            updateNotificationBadge();
        }
        
        // Show success message
        showSuccess('Notification removed');
    }
}

function updateNotificationBadge() {
    const notificationBadge = document.getElementById('notificationBadge');
    const unreadCount = document.querySelectorAll('.notification-item.unread').length;
    
    if (notificationBadge) {
        if (unreadCount > 0) {
            notificationBadge.textContent = unreadCount;
            notificationBadge.style.display = 'block';
        } else {
            notificationBadge.style.display = 'none';
        }
    }
}

// Logout function
function logout() {
    console.log('Opening logout dialog...');
    showLogoutDialog();
}

// Show logout dialog
function showLogoutDialog() {
    const logoutDialog = document.getElementById('logoutDialog');
    if (logoutDialog) {
        logoutDialog.classList.add('show');
        document.body.style.overflow = 'hidden';
    }
}

// Close logout dialog
function closeLogoutDialog() {
    const logoutDialog = document.getElementById('logoutDialog');
    if (logoutDialog) {
        logoutDialog.classList.remove('show');
        document.body.style.overflow = 'auto';
    }
}

// Confirm logout
function confirmLogout() {
    console.log('Logging out...');
    // Clear session data and redirect to login
    window.location.href = 'login.html';
}

// Toggle Switches functionality
function initializeToggleSwitches() {
    const toggleSwitches = document.querySelectorAll('.toggle-switch input');
    
    toggleSwitches.forEach(toggle => {
        toggle.addEventListener('change', function() {
            const configId = this.id;
            const isEnabled = this.checked;
            
            console.log(`Configuration ${configId} changed to:`, isEnabled ? 'ON' : 'OFF');
            
            // Show loading state
            showLoading();
            
            // Simulate API call
            setTimeout(() => {
                hideLoading();
                showSuccess(`Configuration ${configId} updated successfully`);
                
                // In a real implementation, you would:
                // 1. Send the new value to the server
                // 2. Update the database
                // 3. Handle any errors
            }, 1000);
        });
    });
}

// Edit Buttons functionality
function initializeEditButtons() {
    const editButtons = document.querySelectorAll('.edit-btn');
    
    editButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            e.stopPropagation();
            // The onclick handler will be called
        });
    });
}

// Edit Configuration function
function editConfiguration(configId) {
    console.log('Editing configuration:', configId);
    
    // Show loading state
    showLoading();
    
    // Simulate opening edit dialog/modal
    setTimeout(() => {
        hideLoading();
        
        // In a real implementation, you would:
        // 1. Open a modal with the current value
        // 2. Allow the user to edit the value
        // 3. Save the changes to the server
        // 4. Update the table with the new value
        
        showSuccess(`Edit dialog opened for ${configId}`);
        
        // For demo purposes, let's show a simple prompt
        const currentValue = getCurrentValue(configId);
        const newValue = prompt(`Edit ${configId}:`, currentValue);
        
        if (newValue !== null && newValue !== currentValue) {
            updateConfigurationValue(configId, newValue);
        }
    }, 500);
}

// Get current value for a configuration
function getCurrentValue(configId) {
    const row = document.querySelector(`[onclick="editConfiguration('${configId}')"]`).closest('tr');
    const valueCell = row.querySelector('.value-cell');
    
    // Check if it's a toggle switch
    const toggle = valueCell.querySelector('input[type="checkbox"]');
    if (toggle) {
        return toggle.checked ? 'ON' : 'OFF';
    }
    
    // Check if it's an email
    const emailValue = valueCell.querySelector('.email-value');
    if (emailValue) {
        return emailValue.textContent;
    }
    
    // Check if it's a number
    const numberValue = valueCell.querySelector('.number-value');
    if (numberValue) {
        return numberValue.textContent;
    }
    
    return '';
}

// Update configuration value
function updateConfigurationValue(configId, newValue) {
    console.log(`Updating ${configId} to:`, newValue);
    
    // Show loading state
    showLoading();
    
    // Simulate API call
    setTimeout(() => {
        hideLoading();
        
        // Update the UI
        const row = document.querySelector(`[onclick="editConfiguration('${configId}')"]`).closest('tr');
        const valueCell = row.querySelector('.value-cell');
        
        // Check if it's a toggle switch
        const toggle = valueCell.querySelector('input[type="checkbox"]');
        if (toggle) {
            toggle.checked = newValue === 'ON';
        } else {
            // Update text values
            const emailValue = valueCell.querySelector('.email-value');
            const numberValue = valueCell.querySelector('.number-value');
            
            if (emailValue) {
                emailValue.textContent = newValue;
            } else if (numberValue) {
                numberValue.textContent = newValue;
            }
        }
        
        // Update modified timestamp
        const modifiedCell = row.querySelectorAll('.timestamp-cell')[1];
        modifiedCell.textContent = new Date().toISOString().replace('T', ' ').substring(0, 19);
        
        showSuccess(`Configuration ${configId} updated successfully`);
    }, 1000);
}

// Add loading states for better UX
function showLoading() {
    // Add loading spinner or overlay
    const loadingOverlay = document.createElement('div');
    loadingOverlay.className = 'loading-overlay';
    loadingOverlay.innerHTML = '<div class="loading-spinner"></div>';
    document.body.appendChild(loadingOverlay);
}

function hideLoading() {
    // Remove loading spinner
    const loadingOverlay = document.querySelector('.loading-overlay');
    if (loadingOverlay) {
        loadingOverlay.remove();
    }
}

// Error handling
function showError(message) {
    // Create and show error notification
    const errorDiv = document.createElement('div');
    errorDiv.className = 'error-notification';
    errorDiv.textContent = message;
    document.body.appendChild(errorDiv);
    
    // Auto-remove after 5 seconds
    setTimeout(() => {
        errorDiv.remove();
    }, 5000);
}

// Success notification
function showSuccess(message) {
    // Create and show success notification
    const successDiv = document.createElement('div');
    successDiv.className = 'success-notification';
    successDiv.textContent = message;
    document.body.appendChild(successDiv);
    
    // Auto-remove after 3 seconds
    setTimeout(() => {
        successDiv.remove();
    }, 3000);
}

// Add smooth scrolling for better UX
document.addEventListener('DOMContentLoaded', function() {
    // Smooth scroll for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });
});

// Initialize Edit Modal
function initializeEditModal() {
    const editConfigModal = document.getElementById('editConfigModal');
    if (editConfigModal) {
        editConfigModal.style.display = 'none';
    }
}

// Action Menu functionality
function initializeActionMenus() {
    // Close action menus when clicking outside
    document.addEventListener('click', function(e) {
        if (!e.target.closest('.action-menu')) {
            const allMenus = document.querySelectorAll('.action-dropdown');
            allMenus.forEach(menu => {
                menu.classList.remove('show');
            });
        }
    });
}

function toggleActionMenu(menuId) {
    // Close all menus first
    const allMenus = document.querySelectorAll('.action-dropdown');
    allMenus.forEach(menu => {
        menu.style.display = 'none';
    });
    
    // Show the clicked menu - fix the ID format
    const menu = document.getElementById('actionMenu' + menuId.charAt(0).toUpperCase() + menuId.slice(1));
    if (menu) {
        menu.style.display = 'block';
    }
}

// Edit Configuration functionality
function editConfig(configId, valueType, currentValue) {
    const editConfigModal = document.getElementById('editConfigModal');
    const configDescription = document.getElementById('configDescription');
    const configValueContainer = document.getElementById('configValueContainer');
    
    if (editConfigModal) {
        // Set description based on configId
        const descriptions = {
            'maintenance-mode': 'Maintenance Mode ON/OFF',
            'force-refresh': 'Force Refresh',
            'alert-email': 'Alert all user activities',
            'invite-expirations': 'Invite Expirations Days',
            'otp-resend': 'OTP CODE (Re-send)',
            'otp-code': 'OTP CODE',
            'connection-token': 'Connection Token'
        };
        
        configDescription.value = descriptions[configId] || configId;
        
        // Clear previous content
        configValueContainer.innerHTML = '';
        
        // Create appropriate input based on value type
        if (valueType === 'toggle') {
            const toggleContainer = document.createElement('div');
            toggleContainer.className = 'modal-toggle-switch';
            toggleContainer.innerHTML = `
                <input type="checkbox" id="modalToggle" class="toggle-input" ${currentValue ? 'checked' : ''}>
                <label for="modalToggle" class="toggle-label">
                    <span class="toggle-slider"></span>
                </label>
            `;
            configValueContainer.appendChild(toggleContainer);
        } else if (valueType === 'email') {
            const emailInput = document.createElement('input');
            emailInput.type = 'email';
            emailInput.className = 'form-input';
            emailInput.value = currentValue;
            emailInput.placeholder = 'Enter email address';
            configValueContainer.appendChild(emailInput);
        } else if (valueType === 'number') {
            const numberInput = document.createElement('input');
            numberInput.type = 'number';
            numberInput.className = 'form-input';
            numberInput.value = currentValue;
            numberInput.placeholder = 'Enter number';
            configValueContainer.appendChild(numberInput);
        }
        
        // Store current config data for saving
        editConfigModal.dataset.configId = configId;
        editConfigModal.dataset.valueType = valueType;
        
        // Show modal
        editConfigModal.style.display = 'flex';
        document.body.style.overflow = 'hidden';
    }
}

function closeEditModal() {
    const editConfigModal = document.getElementById('editConfigModal');
    if (editConfigModal) {
        editConfigModal.style.display = 'none';
        document.body.style.overflow = 'auto';
    }
}

function saveConfig() {
    const editConfigModal = document.getElementById('editConfigModal');
    const configId = editConfigModal.dataset.configId;
    const valueType = editConfigModal.dataset.valueType;
    
    let newValue;
    
    if (valueType === 'toggle') {
        const toggleInput = document.querySelector('#modalToggle');
        newValue = toggleInput.checked;
    } else if (valueType === 'email') {
        const emailInput = document.querySelector('#configValueContainer input[type="email"]');
        newValue = emailInput.value;
        
        // Basic email validation
        if (!isValidEmail(newValue)) {
            alert('Please enter a valid email address');
            return;
        }
    } else if (valueType === 'number') {
        const numberInput = document.querySelector('#configValueContainer input[type="number"]');
        newValue = parseInt(numberInput.value);
        
        if (isNaN(newValue)) {
            alert('Please enter a valid number');
            return;
        }
    }
    
    // Simulate API call
    showLoading();
    setTimeout(() => {
        hideLoading();
        
        // Update the table display
        updateTableValue(configId, newValue, valueType);
        
        // Close modal
        closeEditModal();
        
        // Show success message
        showNotification('Configuration updated successfully!', 'success');
    }, 1000);
}

function updateTableValue(configId, newValue, valueType) {
    // Update the main table display
    if (valueType === 'toggle') {
        const toggleInput = document.getElementById(configId);
        if (toggleInput) {
            toggleInput.checked = newValue;
        }
    } else if (valueType === 'email') {
        const emailSpan = document.querySelector(`[data-config="${configId}"] .email-value`);
        if (emailSpan) {
            emailSpan.textContent = newValue;
        }
    } else if (valueType === 'number') {
        const numberSpan = document.querySelector(`[data-config="${configId}"] .number-value`);
        if (numberSpan) {
            numberSpan.textContent = newValue;
        }
    }
}

function isValidEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}

function showLoading() {
    // Simple loading indicator
    const loadingDiv = document.createElement('div');
    loadingDiv.id = 'loadingOverlay';
    loadingDiv.style.cssText = `
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0,0,0,0.5);
        display: flex;
        justify-content: center;
        align-items: center;
        z-index: 9999;
    `;
    loadingDiv.innerHTML = '<div style="color: white; font-size: 18px;">Saving...</div>';
    document.body.appendChild(loadingDiv);
}

function hideLoading() {
    const loadingDiv = document.getElementById('loadingOverlay');
    if (loadingDiv) {
        loadingDiv.remove();
    }
}

function showNotification(message, type) {
    // Create notification element
    const notification = document.createElement('div');
    notification.className = `notification ${type}`;
    notification.textContent = message;
    notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: ${type === 'success' ? '#4caf50' : '#f44336'};
        color: white;
        padding: 12px 20px;
        border-radius: 4px;
        z-index: 10000;
        font-size: 14px;
    `;
    
    // Add to page
    document.body.appendChild(notification);
    
    // Remove after 3 seconds
    setTimeout(() => {
        notification.remove();
    }, 3000);
}
