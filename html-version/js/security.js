// Security JavaScript functionality

document.addEventListener('DOMContentLoaded', function() {
    // Initialize interactive elements
    initializeSearchableDropdown();
    initializeNavigation();
    initializeNotifications();
    initializeTabs();
    initializeTables();
    initializeToggleSwitches();
    initializeSuperAdminModal();
    initializeAddProfileModal();
    initializeEditProfileModal();
    initializeViewDetailsModal();
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

// Super Admin Modal functionality
function initializeSuperAdminModal() {
    const newSuperAdminBtn = document.querySelector('button[onclick="createNewSuperAdmin()"]');
    const superAdminModal = document.getElementById('superAdminModal');
    const closeSuperAdminBtn = document.getElementById('closeSuperAdminModal');
    const superAdminCancelBtn = document.getElementById('superAdminCancelBtn');
    const superAdminSaveBtn = document.getElementById('superAdminSaveBtn');
    const superAdminForm = document.getElementById('superAdminForm');
    
    // Open modal when New button is clicked
    if (newSuperAdminBtn) {
        newSuperAdminBtn.addEventListener('click', function(e) {
            e.preventDefault();
            openSuperAdminModal();
        });
    }
    
    // Close modal events
    if (closeSuperAdminBtn) {
        closeSuperAdminBtn.addEventListener('click', closeSuperAdminModal);
    }
    
    if (superAdminCancelBtn) {
        superAdminCancelBtn.addEventListener('click', closeSuperAdminModal);
    }
    
    // Close modal when clicking overlay
    if (superAdminModal) {
        superAdminModal.addEventListener('click', function(e) {
            if (e.target === superAdminModal) {
                closeSuperAdminModal();
            }
        });
    }
    
    // Close modal on escape key
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape' && superAdminModal && superAdminModal.classList.contains('show')) {
            closeSuperAdminModal();
        }
    });
    
    // Form submission
    if (superAdminSaveBtn) {
        superAdminSaveBtn.addEventListener('click', function() {
            saveSuperAdmin();
        });
    }
    
    // Real-time validation
    const formInputs = document.querySelectorAll('#superAdminForm .form-input');
    formInputs.forEach(input => {
        input.addEventListener('blur', function() {
            validateField(this);
        });
        
        input.addEventListener('input', function() {
            clearFieldError(this);
        });
    });
}

// Open Super Admin modal
function openSuperAdminModal() {
    const superAdminModal = document.getElementById('superAdminModal');
    const superAdminForm = document.getElementById('superAdminForm');
    
    if (superAdminModal) {
        // Clear form
        if (superAdminForm) {
            superAdminForm.reset();
            clearAllErrors();
        }
        
        // Show modal
        superAdminModal.classList.add('show');
        document.body.style.overflow = 'hidden';
        
        // Focus on first input
        setTimeout(() => {
            const firstInput = document.getElementById('firstName');
            if (firstInput) {
                firstInput.focus();
            }
        }, 100);
    }
}

// Close Super Admin modal
function closeSuperAdminModal() {
    const superAdminModal = document.getElementById('superAdminModal');
    if (superAdminModal) {
        superAdminModal.classList.remove('show');
        document.body.style.overflow = 'auto';
    }
}

// Save Super Admin
function saveSuperAdmin() {
    const form = document.getElementById('superAdminForm');
    if (!form) return;
    
    const formData = new FormData(form);
    const firstName = document.getElementById('firstName').value.trim();
    const lastName = document.getElementById('lastName').value.trim();
    const email = document.getElementById('email').value.trim();
    const password = document.getElementById('password').value;
    const confirmPassword = document.getElementById('confirmPassword').value;
    
    // Clear previous errors
    clearAllErrors();
    
    let isValid = true;
    
    // Validate First Name
    if (!firstName) {
        showFieldError('firstName', 'First Name is required');
        isValid = false;
    }
    
    // Validate Last Name
    if (!lastName) {
        showFieldError('lastName', 'Last Name is required');
        isValid = false;
    }
    
    // Validate Email
    if (!email) {
        showFieldError('email', 'Email is required');
        isValid = false;
    } else if (!isValidEmail(email)) {
        showFieldError('email', 'Please enter a valid email address');
        isValid = false;
    }
    
    // Validate Password
    if (!password) {
        showFieldError('password', 'Password is required');
        isValid = false;
    } else if (password.length < 6) {
        showFieldError('password', 'Password must be at least 6 characters');
        isValid = false;
    }
    
    // Validate Confirm Password
    if (!confirmPassword) {
        showFieldError('confirmPassword', 'Confirm Password is required');
        isValid = false;
    } else if (password !== confirmPassword) {
        showFieldError('confirmPassword', 'Passwords do not match');
        isValid = false;
    }
    
    if (isValid) {
        // Show loading state
        showLoading();
        
        // Simulate API call
        setTimeout(() => {
            hideLoading();
            showSuccess('Super Admin created successfully!');
            closeSuperAdminModal();
            
            // In a real app, you would send the data to the server
            console.log('Super Admin Data:', {
                firstName,
                lastName,
                email,
                password
            });
        }, 1500);
    }
}

// Validate individual field
function validateField(field) {
    const value = field.value.trim();
    const fieldName = field.id;
    
    clearFieldError(field);
    
    if (!value) {
        showFieldError(fieldName, `${getFieldLabel(fieldName)} is required`);
        return false;
    }
    
    if (fieldName === 'email' && !isValidEmail(value)) {
        showFieldError(fieldName, 'Please enter a valid email address');
        return false;
    }
    
    if (fieldName === 'password' && value.length < 6) {
        showFieldError(fieldName, 'Password must be at least 6 characters');
        return false;
    }
    
    if (fieldName === 'confirmPassword') {
        const password = document.getElementById('password').value;
        if (value !== password) {
            showFieldError(fieldName, 'Passwords do not match');
            return false;
        }
    }
    
    return true;
}

// Show field error
function showFieldError(fieldName, message) {
    const field = document.getElementById(fieldName);
    const errorElement = document.getElementById(fieldName + 'Error');
    
    if (field) {
        field.classList.add('error');
    }
    
    if (errorElement) {
        errorElement.textContent = message;
        errorElement.classList.add('show');
    }
}

// Clear field error
function clearFieldError(field) {
    const fieldName = field.id;
    const errorElement = document.getElementById(fieldName + 'Error');
    
    field.classList.remove('error');
    
    if (errorElement) {
        errorElement.classList.remove('show');
    }
}

// Clear all errors
function clearAllErrors() {
    const errorElements = document.querySelectorAll('.error-message');
    const errorFields = document.querySelectorAll('.form-input.error');
    
    errorElements.forEach(element => {
        element.classList.remove('show');
    });
    
    errorFields.forEach(field => {
        field.classList.remove('error');
    });
}

// Get field label
function getFieldLabel(fieldName) {
    const labels = {
        'firstName': 'First Name',
        'lastName': 'Last Name',
        'email': 'Email',
        'password': 'Password',
        'confirmPassword': 'Confirm Password'
    };
    return labels[fieldName] || fieldName;
}

// Validate email format
function isValidEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}

// Show loading state
function showLoading() {
    const loadingOverlay = document.createElement('div');
    loadingOverlay.className = 'loading-overlay';
    loadingOverlay.innerHTML = '<div class="loading-spinner"></div>';
    document.body.appendChild(loadingOverlay);
}

// Hide loading state
function hideLoading() {
    const loadingOverlay = document.querySelector('.loading-overlay');
    if (loadingOverlay) {
        loadingOverlay.remove();
    }
}

// Show success message
function showSuccess(message) {
    const successDiv = document.createElement('div');
    successDiv.className = 'success-notification';
    successDiv.textContent = message;
    document.body.appendChild(successDiv);
    
    setTimeout(() => {
        successDiv.remove();
    }, 3000);
}

// Override the existing createNewSuperAdmin function
function createNewSuperAdmin() {
    openSuperAdminModal();
}

// Export Admin Table function
function exportAdminTable() {
    showLoading();
    
    setTimeout(() => {
        hideLoading();
        showSuccess('Admin table exported successfully!');
        
        // In a real app, you would generate and download the Excel file
        console.log('Exporting admin table...');
    }, 1500);
}

// Add Profile Modal functionality
function initializeAddProfileModal() {
    const addProfileModal = document.getElementById('addProfileModal');
    const addProfileBtn = document.querySelector('.btn-new-profile');
    const closeAddProfileModalBtn = document.getElementById('closeAddProfileModal');
    const addProfileCancelBtn = document.getElementById('addProfileCancelBtn');
    const addProfileSaveBtn = document.getElementById('addProfileSaveBtn');
    const addProfileForm = document.getElementById('addProfileForm');
    
    // Open modal
    if (addProfileBtn) {
        addProfileBtn.addEventListener('click', openAddProfileModal);
    }
    
    // Close modal
    if (closeAddProfileModalBtn) {
        closeAddProfileModalBtn.addEventListener('click', closeAddProfileModal);
    }
    
    if (addProfileCancelBtn) {
        addProfileCancelBtn.addEventListener('click', closeAddProfileModal);
    }
    
    // Close on overlay click
    if (addProfileModal) {
        addProfileModal.addEventListener('click', function(e) {
            if (e.target === addProfileModal) {
                closeAddProfileModal();
            }
        });
    }
    
    // Save profile
    if (addProfileSaveBtn) {
        addProfileSaveBtn.addEventListener('click', saveProfile);
    }
    
    // Real-time validation
    const formFields = ['profileName', 'description', 'code', 'profileType'];
    formFields.forEach(fieldName => {
        const field = document.getElementById(fieldName);
        if (field) {
            field.addEventListener('blur', () => validateField(fieldName));
            field.addEventListener('input', () => clearFieldError(fieldName));
        }
    });
    
    // Override the existing createNewProfile function
    window.createNewProfile = openAddProfileModal;
}

function openAddProfileModal() {
    const addProfileModal = document.getElementById('addProfileModal');
    if (addProfileModal) {
        addProfileModal.style.display = 'flex';
        document.body.style.overflow = 'hidden';
        clearAllErrors();
        resetForm();
    }
}

function closeAddProfileModal() {
    const addProfileModal = document.getElementById('addProfileModal');
    if (addProfileModal) {
        addProfileModal.style.display = 'none';
        document.body.style.overflow = 'auto';
    }
}

function saveProfile() {
    const profileName = document.getElementById('profileName').value.trim();
    const description = document.getElementById('description').value.trim();
    const code = document.getElementById('code').value.trim();
    const profileType = document.getElementById('profileType').value;
    const verificationRequired = document.getElementById('verificationRequired').checked;
    const practiceRequired = document.getElementById('practiceRequired').checked;
    
    // Clear previous errors
    clearAllErrors();
    
    // Validate required fields
    let isValid = true;
    
    if (!profileName) {
        showFieldError('profileName', 'Profile Name is required');
        isValid = false;
    }
    
    if (!code) {
        showFieldError('code', 'Code is required');
        isValid = false;
    }
    
    if (!profileType) {
        showFieldError('profileType', 'Profile Type is required');
        isValid = false;
    }
    
    if (!isValid) {
        return;
    }
    
    // Show loading state
    showLoading();
    
    // Simulate API call
    setTimeout(() => {
        hideLoading();
        
        // Create profile object
        const profile = {
            name: profileName,
            description: description,
            code: code,
            type: profileType,
            verificationRequired: verificationRequired,
            practiceRequired: practiceRequired,
            createdAt: new Date().toISOString()
        };
        
        console.log('Profile created:', profile);
        
        // Show success message
        showSuccess('Profile created successfully!');
        
        // Close modal
        closeAddProfileModal();
        
        // Here you would typically add the profile to the table
        // addProfileToTable(profile);
        
    }, 1000);
}

function resetForm() {
    const form = document.getElementById('addProfileForm');
    if (form) {
        form.reset();
        document.getElementById('practiceRequired').checked = true; // Default to checked
    }
}

// Edit Profile Modal functionality
function initializeEditProfileModal() {
    const editProfileModal = document.getElementById('editProfileModal');
    const closeEditProfileModalBtn = document.getElementById('closeEditProfileModal');
    const editProfileCancelBtn = document.getElementById('editProfileCancelBtn');
    const editProfileSaveBtn = document.getElementById('editProfileSaveBtn');
    
    // Close modal
    if (closeEditProfileModalBtn) {
        closeEditProfileModalBtn.addEventListener('click', closeEditProfileModal);
    }
    
    if (editProfileCancelBtn) {
        editProfileCancelBtn.addEventListener('click', closeEditProfileModal);
    }
    
    // Close on overlay click
    if (editProfileModal) {
        editProfileModal.addEventListener('click', function(e) {
            if (e.target === editProfileModal) {
                closeEditProfileModal();
            }
        });
    }
    
    // Save profile
    if (editProfileSaveBtn) {
        editProfileSaveBtn.addEventListener('click', saveEditProfile);
    }
    
    // Initialize menu interactions
    initializeMenuInteractions();
    
    // Override the existing editProfile function
    window.editProfile = openEditProfileModal;
}

function openEditProfileModal(profileId) {
    const editProfileModal = document.getElementById('editProfileModal');
    if (editProfileModal) {
        editProfileModal.style.display = 'flex';
        document.body.style.overflow = 'hidden';
        
        // Load profile data (in a real app, this would fetch from API)
        loadProfileData(profileId);
    }
}

function closeEditProfileModal() {
    const editProfileModal = document.getElementById('editProfileModal');
    if (editProfileModal) {
        editProfileModal.style.display = 'none';
        document.body.style.overflow = 'auto';
    }
}

function loadProfileData(profileId) {
    // In a real app, this would fetch data from an API
    // For now, we'll use the existing data from the form
    console.log(`Loading profile data for ID: ${profileId}`);
}

function saveEditProfile() {
    const profileName = document.getElementById('editProfileName').value.trim();
    const description = document.getElementById('editDescription').value.trim();
    const code = document.getElementById('editCode').value.trim();
    const profileType = document.getElementById('editProfileType').value;
    const verificationRequired = document.getElementById('editVerificationRequired').checked;
    const practiceRequired = document.getElementById('editPracticeRequired').checked;
    
    // Get selected menu permissions
    const selectedMenus = getSelectedMenuPermissions();
    
    // Validate required fields
    let isValid = true;
    
    if (!profileName) {
        showFieldError('editProfileName', 'Profile Name is required');
        isValid = false;
    }
    
    if (!code) {
        showFieldError('editCode', 'Code is required');
        isValid = false;
    }
    
    if (!profileType) {
        showFieldError('editProfileType', 'Profile Type is required');
        isValid = false;
    }
    
    if (!isValid) {
        return;
    }
    
    // Show loading state
    showLoading();
    
    // Simulate API call
    setTimeout(() => {
        hideLoading();
        
        // Create profile object
        const profile = {
            id: 'current-profile-id',
            name: profileName,
            description: description,
            code: code,
            type: profileType,
            verificationRequired: verificationRequired,
            practiceRequired: practiceRequired,
            menuPermissions: selectedMenus,
            updatedAt: new Date().toISOString()
        };
        
        console.log('Profile updated:', profile);
        
        // Show success message
        showSuccess('Profile updated successfully!');
        
        // Close modal
        closeEditProfileModal();
        
        // Here you would typically update the profile in the table
        // updateProfileInTable(profile);
        
    }, 1000);
}

function initializeMenuInteractions() {
    // Handle menu expansion/collapse
    const menuItems = document.querySelectorAll('.menu-item');
    menuItems.forEach(item => {
        const arrow = item.querySelector('.menu-arrow');
        const subMenu = item.querySelector('.sub-menu');
        
        if (arrow && subMenu) {
            item.addEventListener('click', function(e) {
                if (!e.target.matches('input[type="checkbox"]') && !e.target.matches('label')) {
                    item.classList.toggle('expanded');
                }
            });
        }
    });
    
    // Handle checkbox interactions
    const checkboxes = document.querySelectorAll('.menu-checkbox');
    checkboxes.forEach(checkbox => {
        checkbox.addEventListener('change', function() {
            handleCheckboxChange(this);
        });
    });
}

function handleCheckboxChange(checkbox) {
    const menuItem = checkbox.closest('.menu-item');
    const parentCheckbox = menuItem.querySelector('.menu-checkbox');
    const subCheckboxes = menuItem.querySelectorAll('.sub-menu .menu-checkbox');
    
    if (checkbox === parentCheckbox) {
        // Parent checkbox changed - update all children
        subCheckboxes.forEach(subCheckbox => {
            subCheckbox.checked = checkbox.checked;
            subCheckbox.classList.remove('indeterminate');
        });
    } else {
        // Child checkbox changed - update parent
        const checkedChildren = Array.from(subCheckboxes).filter(cb => cb.checked);
        const totalChildren = subCheckboxes.length;
        
        if (checkedChildren.length === 0) {
            parentCheckbox.checked = false;
            parentCheckbox.classList.remove('indeterminate');
        } else if (checkedChildren.length === totalChildren) {
            parentCheckbox.checked = true;
            parentCheckbox.classList.remove('indeterminate');
        } else {
            parentCheckbox.checked = false;
            parentCheckbox.classList.add('indeterminate');
        }
    }
}

function getSelectedMenuPermissions() {
    const selectedMenus = [];
    const checkboxes = document.querySelectorAll('.menu-checkbox:checked');
    
    checkboxes.forEach(checkbox => {
        selectedMenus.push(checkbox.id);
    });
    
    return selectedMenus;
}

// View Details Modal functionality
function initializeViewDetailsModal() {
    const viewDetailsModal = document.getElementById('viewDetailsModal');
    const closeViewDetailsModalBtn = document.getElementById('closeViewDetailsModal');
    const viewDetailsCloseBtn = document.getElementById('viewDetailsCloseBtn');
    
    // Close modal
    if (closeViewDetailsModalBtn) {
        closeViewDetailsModalBtn.addEventListener('click', closeViewDetailsModal);
    }
    
    if (viewDetailsCloseBtn) {
        viewDetailsCloseBtn.addEventListener('click', closeViewDetailsModal);
    }
    
    // Close on overlay click
    if (viewDetailsModal) {
        viewDetailsModal.addEventListener('click', function(e) {
            if (e.target === viewDetailsModal) {
                closeViewDetailsModal();
            }
        });
    }
    
    // Initialize pagination
    initializeViewDetailsPagination();
    
    // Override the existing viewUser function
    window.viewUser = openViewDetailsModal;
}

function openViewDetailsModal(userId) {
    const viewDetailsModal = document.getElementById('viewDetailsModal');
    if (viewDetailsModal) {
        viewDetailsModal.style.display = 'flex';
        document.body.style.overflow = 'hidden';
        
        // Load user data (in a real app, this would fetch from API)
        loadUserDetails(userId);
    }
}

function closeViewDetailsModal() {
    const viewDetailsModal = document.getElementById('viewDetailsModal');
    if (viewDetailsModal) {
        viewDetailsModal.style.display = 'none';
        document.body.style.overflow = 'auto';
    }
}

function loadUserDetails(userId) {
    // In a real app, this would fetch data from an API based on userId
    console.log(`Loading user details for ID: ${userId}`);
    
    // For demo purposes, we'll show sample data
    // The data is already in the HTML, but in a real app you'd populate it here
}

function initializeViewDetailsPagination() {
    const firstPageBtn = document.getElementById('firstPageBtn');
    const prevPageBtn = document.getElementById('prevPageBtn');
    const nextPageBtn = document.getElementById('nextPageBtn');
    const lastPageBtn = document.getElementById('lastPageBtn');
    const currentPageBtn = document.getElementById('currentPageBtn');
    
    let currentPage = 1;
    const totalPages = 1; // In a real app, this would be calculated based on data
    
    // Update pagination state
    function updatePaginationState() {
        firstPageBtn.disabled = currentPage === 1;
        prevPageBtn.disabled = currentPage === 1;
        nextPageBtn.disabled = currentPage === totalPages;
        lastPageBtn.disabled = currentPage === totalPages;
        
        currentPageBtn.textContent = currentPage;
        currentPageBtn.classList.toggle('active', true);
    }
    
    // Event listeners
    if (firstPageBtn) {
        firstPageBtn.addEventListener('click', () => {
            currentPage = 1;
            updatePaginationState();
            // In a real app, you'd load the first page of data here
        });
    }
    
    if (prevPageBtn) {
        prevPageBtn.addEventListener('click', () => {
            if (currentPage > 1) {
                currentPage--;
                updatePaginationState();
                // In a real app, you'd load the previous page of data here
            }
        });
    }
    
    if (nextPageBtn) {
        nextPageBtn.addEventListener('click', () => {
            if (currentPage < totalPages) {
                currentPage++;
                updatePaginationState();
                // In a real app, you'd load the next page of data here
            }
        });
    }
    
    if (lastPageBtn) {
        lastPageBtn.addEventListener('click', () => {
            currentPage = totalPages;
            updatePaginationState();
            // In a real app, you'd load the last page of data here
        });
    }
    
    // Initialize pagination state
    updatePaginationState();
}
