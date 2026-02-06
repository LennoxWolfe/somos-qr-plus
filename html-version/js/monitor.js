// Monitor JavaScript functionality

document.addEventListener('DOMContentLoaded', function() {
    // Initialize interactive elements
    initializeSearchableDropdown();
    initializeNavigation();
    initializeNotifications();
    initializeTabs();
    initializeFilters();
    initializeTables();
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
    // 2. Update the monitor data
    // 3. Update any other data on the page
    
    console.log('Updating provider data for:', providerText);
    
    // Show loading state
    showLoading();
    
    // Simulate API call
    setTimeout(() => {
        hideLoading();
        showSuccess('Monitor data updated for ' + providerText);
        
        // Example of how you might update the monitor data
        // updateMonitorData(newData);
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
    const tabBtns = document.querySelectorAll('.tab-btn');
    const tabContents = document.querySelectorAll('.tab-content');
    
    tabBtns.forEach(btn => {
        btn.addEventListener('click', () => {
            const tabId = btn.getAttribute('data-tab');
            
            // Remove active class from all tabs and contents
            tabBtns.forEach(tab => tab.classList.remove('active'));
            tabContents.forEach(content => content.classList.remove('active'));
            
            // Add active class to clicked tab and corresponding content
            btn.classList.add('active');
            document.getElementById(`${tabId}-tab`).classList.add('active');
            
            console.log('Switched to tab:', tabId);
        });
    });
}

// Filters functionality
function initializeFilters() {
    // Search filters
    const logsSearch = document.getElementById('logsSearch');
    const activitySearch = document.getElementById('activitySearch');
    
    if (logsSearch) {
        logsSearch.addEventListener('input', (e) => {
            filterLogsTable(e.target.value);
        });
    }
    
    if (activitySearch) {
        activitySearch.addEventListener('input', (e) => {
            filterActivityTable(e.target.value);
        });
    }
    
    // Dropdown filters
    const userFilter = document.getElementById('userFilter');
    const practiceFilter = document.getElementById('practiceFilter');
    
    if (userFilter) {
        userFilter.addEventListener('change', (e) => {
            filterActivityByUser(e.target.value);
        });
    }
    
    if (practiceFilter) {
        practiceFilter.addEventListener('change', (e) => {
            filterActivityByPractice(e.target.value);
        });
    }
    
    // Date range filters
    const logsPeriod = document.getElementById('logsPeriod');
    const activityPeriod = document.getElementById('activityPeriod');
    
    if (logsPeriod) {
        logsPeriod.addEventListener('change', (e) => {
            filterLogsByPeriod(e.target.value);
        });
    }
    
    if (activityPeriod) {
        activityPeriod.addEventListener('change', (e) => {
            filterActivityByPeriod(e.target.value);
        });
    }
}

// Table functionality
function initializeTables() {
    // Initialize sorting for both tables
    initializeTableSorting('.logs-table');
    initializeTableSorting('.activity-table');
    
    // Initialize pagination
    initializePagination('.logs-table');
    initializePagination('.activity-table');
    
    // Initialize editable fields
    initializeEditableFields();
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
    const table = tableSelector;
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

// Editable Fields functionality
function initializeEditableFields() {
    const editableFields = document.querySelectorAll('.editable-field');
    
    editableFields.forEach(field => {
        // Store original value
        field.setAttribute('data-original-value', field.value);
        
        // Handle focus events
        field.addEventListener('focus', function() {
            this.style.backgroundColor = 'white';
            this.style.border = '1px solid #1976d2';
            this.style.boxShadow = '0 0 0 2px rgba(25, 118, 210, 0.1)';
        });
        
        // Handle blur events (when user clicks away)
        field.addEventListener('blur', function() {
            const originalValue = this.getAttribute('data-original-value');
            const currentValue = this.value;
            
            if (originalValue !== currentValue) {
                // Value has changed, save it
                saveFieldChange(this, originalValue, currentValue);
                this.setAttribute('data-original-value', currentValue);
            }
            
            // Reset styling
            this.style.backgroundColor = 'transparent';
            this.style.border = 'none';
            this.style.boxShadow = 'none';
        });
        
        // Handle Enter key to save
        field.addEventListener('keydown', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                this.blur(); // Trigger blur event to save
            }
            
            if (e.key === 'Escape') {
                e.preventDefault();
                // Revert to original value
                this.value = this.getAttribute('data-original-value');
                this.blur();
            }
        });
    });
}

function saveFieldChange(field, originalValue, newValue) {
    // Get row information
    const row = field.closest('tr');
    const idCell = row.querySelector('.id-cell');
    const logId = idCell ? idCell.textContent : 'unknown';
    
    // Determine field type
    const fieldType = field.closest('.to-cell') ? 'TO' : 'SUBJECT';
    
    console.log(`Saving change for Log ID ${logId}, Field: ${fieldType}`);
    console.log(`Original: ${originalValue}`);
    console.log(`New: ${newValue}`);
    
    // Show loading state
    showLoading();
    
    // Simulate API call
    setTimeout(() => {
        hideLoading();
        showSuccess(`Log ${logId} ${fieldType} field updated successfully`);
        
        // In a real implementation, you would:
        // 1. Send the change to the server
        // 2. Update the database
        // 3. Handle any errors
        // 4. Update any related UI elements
    }, 1000);
}

// Filter functions
function filterLogsTable(searchTerm) {
    const table = document.querySelector('.logs-table tbody');
    const rows = table.querySelectorAll('tr');
    
    rows.forEach(row => {
        const text = row.textContent.toLowerCase();
        if (text.includes(searchTerm.toLowerCase())) {
            row.style.display = '';
        } else {
            row.style.display = 'none';
        }
    });
}

function filterActivityTable(searchTerm) {
    const table = document.querySelector('.activity-table tbody');
    const rows = table.querySelectorAll('tr');
    
    rows.forEach(row => {
        const text = row.textContent.toLowerCase();
        if (text.includes(searchTerm.toLowerCase())) {
            row.style.display = '';
        } else {
            row.style.display = 'none';
        }
    });
}

function filterActivityByUser(userValue) {
    const table = document.querySelector('.activity-table tbody');
    const rows = table.querySelectorAll('tr');
    
    rows.forEach(row => {
        const firstName = row.querySelector('.first-name-cell').textContent.toLowerCase();
        const lastName = row.querySelector('.last-name-cell').textContent.toLowerCase();
        const fullName = `${firstName} ${lastName}`.toLowerCase();
        
        if (!userValue || fullName.includes(userValue.toLowerCase())) {
            row.style.display = '';
        } else {
            row.style.display = 'none';
        }
    });
}

function filterActivityByPractice(practiceValue) {
    const table = document.querySelector('.activity-table tbody');
    const rows = table.querySelectorAll('tr');
    
    rows.forEach(row => {
        const practice = row.querySelector('.practice-cell').textContent.toLowerCase();
        
        if (!practiceValue || practice.includes(practiceValue.toLowerCase())) {
            row.style.display = '';
        } else {
            row.style.display = 'none';
        }
    });
}

function filterLogsByPeriod(periodValue) {
    console.log('Filtering logs by period:', periodValue);
    // Implementation would filter logs by date range
}

function filterActivityByPeriod(periodValue) {
    console.log('Filtering activity by period:', periodValue);
    // Implementation would filter activity by date range
}

// Date range functions
function clearDateRange(inputId) {
    const input = document.getElementById(inputId);
    if (input) {
        input.value = '';
        console.log('Cleared date range for', inputId);
    }
}

function openDatePicker(inputId) {
    const input = document.getElementById(inputId);
    if (input) {
        input.focus();
        console.log('Opening date picker for', inputId);
    }
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

// Export Activity Table to Excel (CSV format)
function exportActivityTable() {
    const table = document.querySelector('.activity-table');
    if (!table) {
        showError('Activity table not found');
        return;
    }
    
    // Get all visible rows (respecting filters)
    const tbody = table.querySelector('tbody');
    const rows = Array.from(tbody.querySelectorAll('tr')).filter(row => 
        row.style.display !== 'none'
    );
    
    if (rows.length === 0) {
        showError('No data to export');
        return;
    }
    
    // Get headers
    const headers = Array.from(table.querySelectorAll('thead th')).map(th => 
        th.textContent.trim().replace(/\s+/g, ' ')
    );
    
    // Build CSV content
    let csvContent = headers.join(',') + '\n';
    
    rows.forEach(row => {
        const cells = Array.from(row.querySelectorAll('td'));
        const rowData = cells.map(cell => {
            // Get text content and clean it
            let text = cell.textContent.trim();
            // Replace commas and newlines with spaces
            text = text.replace(/,/g, ' ').replace(/\n/g, ' ').replace(/\r/g, '');
            // Escape quotes
            text = text.replace(/"/g, '""');
            // Wrap in quotes if contains spaces or special characters
            if (text.includes(' ') || text.includes('"')) {
                return `"${text}"`;
            }
            return text;
        });
        csvContent += rowData.join(',') + '\n';
    });
    
    // Create blob and download
    const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
    const link = document.createElement('a');
    const url = URL.createObjectURL(blob);
    
    // Generate filename with current date
    const now = new Date();
    const dateStr = now.toISOString().split('T')[0]; // YYYY-MM-DD format
    const filename = `activity_export_${dateStr}.csv`;
    
    link.setAttribute('href', url);
    link.setAttribute('download', filename);
    link.style.display = 'none';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    
    // Show success message
    showSuccess(`Exported ${rows.length} rows to ${filename}`);
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
