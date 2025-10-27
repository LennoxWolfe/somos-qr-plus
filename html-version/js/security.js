// Security JavaScript functionality

document.addEventListener('DOMContentLoaded', function() {
    // Initialize interactive elements
    initializeSearchableDropdown();
    initializeNavigation();
    initializeNotifications();
    initializeTabs();
    initializeTables();
    initializeToggleSwitches();
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
    // 2. Update the security data
    // 3. Update any other data on the page
    
    console.log('Updating provider data for:', providerText);
    
    // Show loading state
    showLoading();
    
    // Simulate API call
    setTimeout(() => {
        hideLoading();
        showSuccess('Security data updated for ' + providerText);
        
        // Example of how you might update the security data
        // updateSecurityData(newData);
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

// Tab functionality
function initializeTabs() {
    // Main tabs
    const mainTabBtns = document.querySelectorAll('.main-tab-btn');
    const mainTabContents = document.querySelectorAll('.tab-content');
    
    mainTabBtns.forEach(btn => {
        btn.addEventListener('click', () => {
            const tabId = btn.getAttribute('data-tab');
            
            // Remove active class from all main tabs and contents
            mainTabBtns.forEach(tab => tab.classList.remove('active'));
            mainTabContents.forEach(content => content.classList.remove('active'));
            
            // Add active class to clicked tab and corresponding content
            btn.classList.add('active');
            document.getElementById(`${tabId}-tab`).classList.add('active');
            
            console.log('Switched to main tab:', tabId);
        });
    });
    
    // Sub tabs (only visible when Users tab is active)
    const subTabBtns = document.querySelectorAll('.sub-tab-btn');
    const subTabContents = document.querySelectorAll('.sub-tab-content');
    
    subTabBtns.forEach(btn => {
        btn.addEventListener('click', () => {
            const subtabId = btn.getAttribute('data-subtab');
            
            // Remove active class from all sub tabs and contents
            subTabBtns.forEach(tab => tab.classList.remove('active'));
            subTabContents.forEach(content => content.classList.remove('active'));
            
            // Add active class to clicked tab and corresponding content
            btn.classList.add('active');
            document.getElementById(`${subtabId}-tab`).classList.add('active');
            
            console.log('Switched to sub tab:', subtabId);
        });
    });
}

// Table functionality
function initializeTables() {
    // Initialize sorting for both tables
    initializeTableSorting('.users-table');
    initializeTableSorting('.profiles-table');
    
    // Initialize pagination
    initializePagination('.users-table');
    initializePagination('.profiles-table');
    
    // Initialize filters
    initializeFilters();
}

function initializeTableSorting(tableSelector) {
    const table = document.querySelector(tableSelector);
    if (!table) return;
    
    const sortableHeaders = table.querySelectorAll('.sortable');
    
    sortableHeaders.forEach(header => {
        header.addEventListener('click', () => {
            const column = header.getAttribute('data-column');
            const currentSort = header.getAttribute('data-sort');
            const newSort = currentSort === 'asc' ? 'desc' : 'asc';
            
            // Remove sort attributes from all headers
            sortableHeaders.forEach(h => {
                h.removeAttribute('data-sort');
                const arrows = h.querySelector('.sort-arrows');
                if (arrows) arrows.textContent = '↕';
            });
            
            // Set new sort on clicked header
            header.setAttribute('data-sort', newSort);
            const arrows = header.querySelector('.sort-arrows');
            if (arrows) arrows.textContent = newSort === 'asc' ? '↑' : '↓';
            
            // Sort the table
            sortTable(table, column, newSort);
            
            console.log(`Sorted ${tableSelector} by ${column} ${newSort}`);
        });
    });
}

function sortTable(table, column, direction) {
    const tbody = table.querySelector('tbody');
    const rows = Array.from(tbody.querySelectorAll('tr'));
    
    rows.sort((a, b) => {
        const aValue = getCellValue(a, column);
        const bValue = getCellValue(b, column);
        
        if (direction === 'asc') {
            return aValue > bValue ? 1 : -1;
        } else {
            return aValue < bValue ? 1 : -1;
        }
    });
    
    // Re-append sorted rows
    rows.forEach(row => tbody.appendChild(row));
}

function getCellValue(row, column) {
    const cellIndex = getColumnIndex(row.closest('table'), column);
    const cell = row.children[cellIndex];
    return cell ? cell.textContent.trim() : '';
}

function getColumnIndex(table, column) {
    const headers = table.querySelectorAll('th');
    for (let i = 0; i < headers.length; i++) {
        if (headers[i].getAttribute('data-column') === column) {
            return i;
        }
    }
    return 0;
}

function initializePagination(tableSelector) {
    const paginationBtns = document.querySelectorAll(`${tableSelector} + .table-section .pagination-btn`);
    
    paginationBtns.forEach(btn => {
        btn.addEventListener('click', () => {
            if (btn.disabled) return;
            
            const pageNum = btn.textContent.trim();
            
            if (pageNum === '«') {
                goToFirstPage(tableSelector);
            } else if (pageNum === '‹') {
                goToPreviousPage(tableSelector);
            } else if (pageNum === '›') {
                goToNextPage(tableSelector);
            } else if (pageNum === '»') {
                goToLastPage(tableSelector);
            } else {
                goToPage(tableSelector, parseInt(pageNum));
            }
        });
    });
}

function goToFirstPage(tableSelector) {
    console.log('Going to first page for', tableSelector);
    updatePaginationButtons(tableSelector, 1);
}

function goToPreviousPage(tableSelector) {
    console.log('Going to previous page for', tableSelector);
    // Implementation would depend on current page tracking
}

function goToNextPage(tableSelector) {
    console.log('Going to next page for', tableSelector);
    // Implementation would depend on current page tracking
}

function goToLastPage(tableSelector) {
    console.log('Going to last page for', tableSelector);
    updatePaginationButtons(tableSelector, 5); // Assuming 5 pages total
}

function goToPage(tableSelector, pageNum) {
    console.log('Going to page', pageNum, 'for', tableSelector);
    updatePaginationButtons(tableSelector, pageNum);
}

function updatePaginationButtons(tableSelector, currentPage) {
    const paginationBtns = document.querySelectorAll(`${tableSelector} + .table-section .pagination-btn`);
    
    paginationBtns.forEach(btn => {
        btn.classList.remove('active');
        if (btn.textContent.trim() === currentPage.toString()) {
            btn.classList.add('active');
        }
    });
}

// Filter functionality
function initializeFilters() {
    const superAdminFilter = document.getElementById('superAdminFilter');
    const adminFilter = document.getElementById('adminFilter');
    
    if (superAdminFilter) {
        superAdminFilter.addEventListener('input', (e) => {
            filterUsersTable('.users-table', e.target.value, 'super-admin');
        });
    }
    
    if (adminFilter) {
        adminFilter.addEventListener('input', (e) => {
            filterUsersTable('.users-table', e.target.value, 'admin');
        });
    }
}

function filterUsersTable(tableSelector, searchTerm, userType) {
    const table = document.querySelector(tableSelector);
    const tbody = table.querySelector('tbody');
    const rows = tbody.querySelectorAll('tr');
    
    rows.forEach(row => {
        const text = row.textContent.toLowerCase();
        if (text.includes(searchTerm.toLowerCase())) {
            row.style.display = '';
        } else {
            row.style.display = 'none';
        }
    });
}

// Toggle switches functionality
function initializeToggleSwitches() {
    const toggleSwitches = document.querySelectorAll('.toggle-switch input');
    
    toggleSwitches.forEach(toggle => {
        toggle.addEventListener('change', function() {
            const userId = this.id.split('-')[1];
            const isActive = this.checked;
            
            updateUserStatus(userId, isActive);
        });
    });
}

function updateUserStatus(userId, isActive) {
    console.log(`Updating user ${userId} status to ${isActive ? 'active' : 'inactive'}`);
    
    // Show loading state
    showLoading();
    
    // Simulate API call
    setTimeout(() => {
        hideLoading();
        showSuccess(`User ${userId} status updated to ${isActive ? 'active' : 'inactive'}`);
        
        // In a real implementation, you would:
        // 1. Send the status change to the server
        // 2. Update the database
        // 3. Handle any errors
        // 4. Update any related UI elements
    }, 1000);
}

// Action button functions
function refreshSuperAdmin() {
    console.log('Refreshing Super Admin data...');
    showLoading();
    
    setTimeout(() => {
        hideLoading();
        showSuccess('Super Admin data refreshed');
    }, 1000);
}

function refreshAdmin() {
    console.log('Refreshing Admin data...');
    showLoading();
    
    setTimeout(() => {
        hideLoading();
        showSuccess('Admin data refreshed');
    }, 1000);
}

function refreshProfiles() {
    console.log('Refreshing Profiles data...');
    showLoading();
    
    setTimeout(() => {
        hideLoading();
        showSuccess('Profiles data refreshed');
    }, 1000);
}

function deleteSelectedSuperAdmin() {
    console.log('Deleting selected Super Admin users...');
    showLoading();
    
    setTimeout(() => {
        hideLoading();
        showSuccess('Selected Super Admin users deleted');
    }, 1000);
}

function deleteSelectedAdmin() {
    console.log('Deleting selected Admin users...');
    showLoading();
    
    setTimeout(() => {
        hideLoading();
        showSuccess('Selected Admin users deleted');
    }, 1000);
}

function createNewSuperAdmin() {
    console.log('Creating new Super Admin user...');
    showLoading();
    
    setTimeout(() => {
        hideLoading();
        showSuccess('New Super Admin user created');
    }, 1000);
}

function createNewAdmin() {
    console.log('Creating new Admin user...');
    showLoading();
    
    setTimeout(() => {
        hideLoading();
        showSuccess('New Admin user created');
    }, 1000);
}

function createNewProfile() {
    console.log('Creating new profile...');
    showLoading();
    
    setTimeout(() => {
        hideLoading();
        showSuccess('New profile created');
    }, 1000);
}

function viewUser(userId) {
    console.log(`Viewing user ${userId}...`);
    showLoading();
    
    setTimeout(() => {
        hideLoading();
        showSuccess(`User ${userId} details loaded`);
    }, 1000);
}

function editProfile(profileId) {
    console.log(`Editing profile ${profileId}...`);
    showLoading();
    
    setTimeout(() => {
        hideLoading();
        showSuccess(`Profile ${profileId} edit mode activated`);
    }, 1000);
}

function deleteProfile(profileId) {
    console.log(`Deleting profile ${profileId}...`);
    showLoading();
    
    setTimeout(() => {
        hideLoading();
        showSuccess(`Profile ${profileId} deleted`);
    }, 1000);
}

// Action Menu functionality
function toggleActionMenu(menuId) {
    // Close all other menus first
    const allMenus = document.querySelectorAll('.action-menu-dropdown');
    allMenus.forEach(menu => {
        if (menu.id !== `actionMenu${menuId}`) {
            menu.classList.remove('show');
        }
    });
    
    // Toggle the clicked menu
    const menu = document.getElementById(`actionMenu${menuId}`);
    if (menu) {
        menu.classList.toggle('show');
    }
}

// Close action menus when clicking outside
document.addEventListener('click', function(e) {
    if (!e.target.closest('.action-menu')) {
        const allMenus = document.querySelectorAll('.action-menu-dropdown');
        allMenus.forEach(menu => {
            menu.classList.remove('show');
        });
    }
});

// Close action menus on escape key
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        const allMenus = document.querySelectorAll('.action-menu-dropdown');
        allMenus.forEach(menu => {
            menu.classList.remove('show');
        });
    }
});

// User action functions
function editUser(userId) {
    console.log(`Editing user ${userId}...`);
    showLoading();
    
    setTimeout(() => {
        hideLoading();
        showSuccess(`User ${userId} edit mode activated`);
    }, 1000);
}

function deleteUser(userId) {
    console.log(`Deleting user ${userId}...`);
    showLoading();
    
    setTimeout(() => {
        hideLoading();
        showSuccess(`User ${userId} deleted`);
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
