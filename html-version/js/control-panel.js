// Control Panel JavaScript functionality

document.addEventListener('DOMContentLoaded', function() {
    // Initialize interactive elements
    initializeSearchableDropdown();
    initializeNavigation();
    initializeNotifications();
    initializePeriodSelector();
    initializeCategories();
    initializeTable();
    initializeViewToggle();
    
    // Initialize connections table functionality
    initializeConnectionsTable();
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
    
    // Initialize profile dropdown
    initializeProfileDropdown();
}

// Close drawer function
function closeDrawer() {
    const navDrawer = document.getElementById('navDrawer');
    const drawerOverlay = document.getElementById('drawerOverlay');
    
    navDrawer.classList.remove('open');
    drawerOverlay.classList.remove('active');
    document.body.style.overflow = ''; // Restore scrolling
}

// Searchable Dropdown Functionality
function initializeSearchableDropdown() {
    const dropdown = document.getElementById('searchableDropdown');
    const trigger = document.getElementById('dropdownTrigger');
    const menu = document.getElementById('dropdownMenu');
    const searchInput = document.getElementById('searchInput');
    const options = document.querySelectorAll('.dropdown-option');
    const selectedText = document.getElementById('selectedText');
    
    let isOpen = false;
    
    // Toggle dropdown
    trigger.addEventListener('click', function(e) {
        e.stopPropagation();
        toggleDropdown();
    });
    
    // Close dropdown when clicking outside
    document.addEventListener('click', function(e) {
        if (!dropdown.contains(e.target)) {
            closeDropdown();
        }
    });
    
    // Handle search input
    searchInput.addEventListener('input', function() {
        const searchTerm = this.value.toLowerCase();
        filterOptions(searchTerm);
    });
    
    // Handle option selection
    options.forEach(option => {
        option.addEventListener('click', function() {
            const value = this.getAttribute('data-value');
            const text = this.querySelector('.option-text').textContent;
            
            // Update selected option
            updateSelectedOption(value, text);
            
            // Close dropdown
            closeDropdown();
            
            // Clear search
            searchInput.value = '';
            showAllOptions();
            
            // Trigger change event
            updateProviderData(value, text);
        });
    });
    
    // Handle keyboard navigation
    searchInput.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            closeDropdown();
        } else if (e.key === 'Enter') {
            e.preventDefault();
            const visibleOptions = document.querySelectorAll('.dropdown-option:not(.hidden)');
            if (visibleOptions.length > 0) {
                visibleOptions[0].click();
            }
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
    // 2. Update the KPI cards
    // 3. Update any other data on the page
    
    console.log('Updating provider data for:', providerText);
    
    // Show loading state
    showLoading();
    
    // Simulate API call
    setTimeout(() => {
        hideLoading();
        showSuccess('Control panel updated for ' + providerText);
        
        // Example of how you might update the control panel data
        // updateKPICards(newData);
    }, 1000);
}

// Period Selector Functionality
function initializePeriodSelector() {
    const periodInput = document.getElementById('periodInput');
    
    if (periodInput) {
        // Format input as MM/YYYY
        periodInput.addEventListener('input', function() {
            let value = this.value.replace(/\D/g, ''); // Remove non-digits
            
            if (value.length >= 2) {
                value = value.substring(0, 2) + '/' + value.substring(2, 6);
            }
            
            this.value = value;
        });
        
        // Handle period change
        periodInput.addEventListener('change', function() {
            const period = this.value;
            console.log('Period changed to:', period);
            
            // Validate period format
            if (isValidPeriod(period)) {
                updateControlPanelData(period);
            } else {
                showError('Please enter a valid period in MM/YYYY format');
                this.value = '10/2025'; // Reset to default
            }
        });
        
        // Handle Enter key
        periodInput.addEventListener('keydown', function(e) {
            if (e.key === 'Enter') {
                this.blur(); // Trigger change event
            }
        });
    }
}

// Validate period format
function isValidPeriod(period) {
    const regex = /^(0[1-9]|1[0-2])\/\d{4}$/;
    return regex.test(period);
}

// Update Control Panel Data (placeholder function)
function updateControlPanelData(period) {
    // This function would typically:
    // 1. Make API calls to fetch data for the selected period
    // 2. Update the KPI cards with new data
    // 3. Update any other period-specific data
    
    console.log('Updating control panel data for period:', period);
    
    // Show loading state
    showLoading();
    
    // Simulate API call
    setTimeout(() => {
        hideLoading();
        showSuccess('Control panel updated for ' + period);
        
        // Example of how you might update the KPI cards
        // updateKPICards(newData);
    }, 1000);
}

// Utility function to update KPI cards
function updateKPICards(data) {
    const kpiCards = document.querySelectorAll('.kpi-card');
    
    kpiCards.forEach((card, index) => {
        const valueElement = card.querySelector('.kpi-value');
        if (valueElement && data.kpiValues && data.kpiValues[index]) {
            valueElement.textContent = data.kpiValues[index];
        }
    });
}

// Profile Dropdown functionality
function initializeProfileDropdown() {
    const profileBtn = document.querySelector('.profile-btn');
    const profileDropdown = document.getElementById('profileDropdown');
    
    // Close dropdown when clicking outside
    document.addEventListener('click', (e) => {
        if (profileDropdown && !profileDropdown.contains(e.target) && !profileBtn.contains(e.target)) {
            closeProfileDropdown();
        }
    });
    
    // Close on escape key
    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape' && profileDropdown && profileDropdown.classList.contains('show')) {
            closeProfileDropdown();
        }
    });
    
    // Handle dropdown options
    const dropdownOptions = document.querySelectorAll('.profile-option');
    dropdownOptions.forEach(option => {
        option.addEventListener('click', (e) => {
            e.preventDefault();
            const action = option.getAttribute('data-action');
            handleProfileAction(action);
        });
    });
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

function handleProfileAction(action) {
    switch(action) {
        case 'language':
            console.log('Language settings clicked');
            // TODO: Implement language selection
            break;
        case 'invitations':
            console.log('Invitations clicked');
            window.location.href = 'invitation.html';
            break;
        case 'logout':
            console.log('Logout clicked from profile dropdown');
            showLogoutDialog();
            break;
        default:
            console.log('Unknown profile action:', action);
    }
    closeProfileDropdown();
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

// Categories functionality
function initializeCategories() {
    // All categories start collapsed by default
    // No need to expand any category on load
}

// Toggle category function
function toggleCategory(categoryId, forceExpand = false) {
    const content = document.getElementById(`${categoryId}-content`);
    const toggle = document.getElementById(`${categoryId}-toggle`);
    
    if (!content || !toggle) return;
    
    const isExpanded = content.classList.contains('expanded');
    
    if (forceExpand || !isExpanded) {
        // Expand
        content.classList.add('expanded');
        toggle.textContent = '▲';
    } else {
        // Collapse
        content.classList.remove('expanded');
        toggle.textContent = '▼';
    }
}

// Table functionality
function initializeTable() {
    // Export button functionality
    const exportBtn = document.querySelector('.btn-export');
    if (exportBtn) {
        exportBtn.addEventListener('click', function() {
            exportTableData();
        });
    }
    
    // Pagination functionality
    const paginationBtns = document.querySelectorAll('.pagination-btn');
    paginationBtns.forEach(btn => {
        btn.addEventListener('click', function() {
            if (!this.disabled) {
                handlePagination(this);
            }
        });
    });
    
    // Table row click functionality
    const tableRows = document.querySelectorAll('.metrics-table tbody tr');
    tableRows.forEach(row => {
        row.addEventListener('click', function() {
            const mcoName = this.querySelector('.mco-name').textContent;
            showMCODetails(mcoName);
        });
    });
}

// Export table data
function exportTableData() {
    console.log('Exporting table data...');
    
    // Show loading state
    showLoading();
    
    // Simulate export process
    setTimeout(() => {
        hideLoading();
        showSuccess('Table data exported successfully');
        
        // In a real implementation, you would:
        // 1. Collect table data
        // 2. Format it (CSV, Excel, etc.)
        // 3. Trigger download
    }, 1500);
}

// Handle pagination
function handlePagination(clickedBtn) {
    const paginationBtns = document.querySelectorAll('.pagination-btn');
    
    // Remove active class from all buttons
    paginationBtns.forEach(btn => {
        btn.classList.remove('active');
    });
    
    // Add active class to clicked button
    clickedBtn.classList.add('active');
    
    // Update disabled states
    updatePaginationStates(clickedBtn);
    
    // Show success message
    const pageNumber = clickedBtn.querySelector('span').textContent;
    if (!isNaN(pageNumber)) {
        showSuccess(`Navigated to page ${pageNumber}`);
    }
}

// Update pagination button states
function updatePaginationStates(activeBtn) {
    const paginationBtns = document.querySelectorAll('.pagination-btn');
    const activePage = parseInt(activeBtn.querySelector('span').textContent);
    
    // Enable/disable first and previous buttons
    paginationBtns[0].disabled = activePage <= 1; // First page
    paginationBtns[1].disabled = activePage <= 1; // Previous page
    
    // Enable/disable next and last buttons
    paginationBtns[3].disabled = activePage >= 5; // Next page (assuming 5 pages max)
    paginationBtns[4].disabled = activePage >= 5; // Last page
}

// Show MCO details
function showMCODetails(mcoName) {
    console.log('Showing details for MCO:', mcoName);
    
    // In a real implementation, you would:
    // 1. Open a modal with detailed MCO information
    // 2. Navigate to a detailed MCO page
    // 3. Show additional metrics for the selected MCO
    
    showSuccess(`Viewing details for ${mcoName}`);
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

// Initialize Connections Table functionality
function initializeConnectionsTable() {
    const searchInput = document.getElementById('connectionsSearch');
    const sendEmailBtn = document.querySelector('.btn-send-email');
    const exportExcelBtn = document.querySelector('.btn-export-excel');
    const sortableHeaders = document.querySelectorAll('.connections-table .sortable');
    const paginationBtns = document.querySelectorAll('.connections-table-section .pagination-btn');
    
    // Search functionality
    if (searchInput) {
        searchInput.addEventListener('input', function() {
            const searchTerm = this.value.toLowerCase();
            const tableRows = document.querySelectorAll('.connections-table tbody tr');
            
            tableRows.forEach(row => {
                const text = row.textContent.toLowerCase();
                if (text.includes(searchTerm)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        });
    }
    
    // Send Email button
    if (sendEmailBtn) {
        sendEmailBtn.addEventListener('click', function() {
            showNotification('Email functionality will be implemented', 'info');
        });
    }
    
    // Export to Excel button
    if (exportExcelBtn) {
        exportExcelBtn.addEventListener('click', function() {
            exportConnectionsData();
        });
    }
    
    // Sortable headers
    sortableHeaders.forEach(header => {
        header.addEventListener('click', function() {
            const column = this.dataset.column;
            sortConnectionsTable(column);
        });
    });
    
    // Pagination
    paginationBtns.forEach(btn => {
        btn.addEventListener('click', function() {
            if (!this.disabled) {
                handleConnectionsPagination(this);
            }
        });
    });
    
    // Items per page selector
    const itemsPerPageSelect = document.getElementById('itemsPerPage');
    if (itemsPerPageSelect) {
        itemsPerPageSelect.addEventListener('change', function() {
            const itemsPerPage = parseInt(this.value);
            updateItemsPerPage(itemsPerPage);
        });
    }
}

// Export connections data
function exportConnectionsData() {
    showNotification('Exporting connections data...', 'info');
    
    setTimeout(() => {
        showNotification('Connections data exported successfully!', 'success');
    }, 1500);
}

// Sort connections table
function sortConnectionsTable(column) {
    const table = document.querySelector('.connections-table');
    const tbody = table.querySelector('tbody');
    const rows = Array.from(tbody.querySelectorAll('tr'));
    
    rows.sort((a, b) => {
        let aVal, bVal;
        
        switch(column) {
            case 'practices':
                aVal = a.querySelector('.practices-cell').textContent.trim();
                bVal = b.querySelector('.practices-cell').textContent.trim();
                break;
            case 'npi':
                aVal = a.querySelector('.npi-cell').textContent.trim();
                bVal = b.querySelector('.npi-cell').textContent.trim();
                break;
            case 'pcp':
                aVal = a.querySelector('.pcp-cell').textContent.trim();
                bVal = b.querySelector('.pcp-cell').textContent.trim();
                break;
            case 'user':
                aVal = a.querySelector('.user-cell').textContent.trim();
                bVal = b.querySelector('.user-cell').textContent.trim();
                break;
        }
        
        return aVal.localeCompare(bVal);
    });
    
    // Clear tbody and append sorted rows
    tbody.innerHTML = '';
    rows.forEach(row => tbody.appendChild(row));
    
    showNotification(`Table sorted by ${column}`, 'info');
}

// Handle connections pagination
function handleConnectionsPagination(clickedBtn) {
    const paginationBtns = document.querySelectorAll('.connections-table-section .pagination-btn');
    
    // Remove active class from all buttons
    paginationBtns.forEach(btn => btn.classList.remove('active'));
    
    // Add active class to clicked button
    clickedBtn.classList.add('active');
    
    // Update disabled states
    updateConnectionsPaginationStates(clickedBtn);
    
    showNotification('Page changed', 'info');
}

// Update connections pagination states
function updateConnectionsPaginationStates(activeBtn) {
    const paginationBtns = document.querySelectorAll('.connections-table-section .pagination-btn');
    const activeIndex = Array.from(paginationBtns).indexOf(activeBtn);
    
    // Enable/disable navigation buttons
    paginationBtns.forEach((btn, index) => {
        if (index < 2) { // First two buttons (<< and <)
            btn.disabled = activeIndex <= 2;
        } else if (index >= paginationBtns.length - 2) { // Last two buttons (> and >>)
            btn.disabled = activeIndex >= paginationBtns.length - 3;
        }
    });
}

// Update items per page
function updateItemsPerPage(itemsPerPage) {
    const tableRows = document.querySelectorAll('.connections-table tbody tr');
    const totalItems = tableRows.length;
    const totalPages = Math.ceil(totalItems / itemsPerPage);
    
    // Hide all rows first
    tableRows.forEach(row => {
        row.style.display = 'none';
    });
    
    // Show only the items for the current page
    const startIndex = 0;
    const endIndex = Math.min(itemsPerPage, totalItems);
    
    for (let i = startIndex; i < endIndex; i++) {
        if (tableRows[i]) {
            tableRows[i].style.display = '';
        }
    }
    
    // Update pagination status
    updatePaginationStatus(1, itemsPerPage, totalItems);
    
    // Update pagination buttons
    updatePaginationButtons(totalPages, 1);
    
    showNotification(`Showing ${itemsPerPage} items per page`, 'info');
}

// Update pagination status text
function updatePaginationStatus(currentPage, itemsPerPage, totalItems) {
    const statusElement = document.querySelector('.pagination-status');
    if (statusElement) {
        const startItem = (currentPage - 1) * itemsPerPage + 1;
        const endItem = Math.min(currentPage * itemsPerPage, totalItems);
        statusElement.textContent = `Showing ${startItem}-${endItem} of ${totalItems} items`;
    }
}

// Update pagination buttons
function updatePaginationButtons(totalPages, currentPage) {
    const paginationContainer = document.querySelector('.connections-table-section .pagination');
    if (!paginationContainer) return;
    
    // Clear existing buttons
    paginationContainer.innerHTML = '';
    
    // Add navigation buttons
    const prevBtn = createPaginationButton('«', currentPage <= 1);
    const prevPageBtn = createPaginationButton('‹', currentPage <= 1);
    
    paginationContainer.appendChild(prevBtn);
    paginationContainer.appendChild(prevPageBtn);
    
    // Add page number buttons
    for (let i = 1; i <= totalPages; i++) {
        const pageBtn = createPaginationButton(i.toString(), false, i === currentPage);
        paginationContainer.appendChild(pageBtn);
    }
    
    // Add next buttons
    const nextPageBtn = createPaginationButton('›', currentPage >= totalPages);
    const nextBtn = createPaginationButton('»', currentPage >= totalPages);
    
    paginationContainer.appendChild(nextPageBtn);
    paginationContainer.appendChild(nextBtn);
    
    // Add event listeners to new buttons
    const newButtons = paginationContainer.querySelectorAll('.pagination-btn');
    newButtons.forEach(btn => {
        btn.addEventListener('click', function() {
            if (!this.disabled) {
                handleConnectionsPagination(this);
            }
        });
    });
}

// Create pagination button
function createPaginationButton(text, disabled = false, active = false) {
    const button = document.createElement('button');
    button.className = 'pagination-btn';
    if (disabled) button.disabled = true;
    if (active) button.classList.add('active');
    
    const span = document.createElement('span');
    span.textContent = text;
    button.appendChild(span);
    
    return button;
}

// View Toggle functionality
function initializeViewToggle() {
    const toggleButtons = document.querySelectorAll('.toggle-btn');
    const tableContainer = document.querySelector('.table-container');
    const graphContainer = document.getElementById('mcoGraph');
    
    toggleButtons.forEach(button => {
        button.addEventListener('click', () => {
            const view = button.getAttribute('data-view');
            
            // Remove active class from all buttons
            toggleButtons.forEach(btn => btn.classList.remove('active'));
            // Add active class to clicked button
            button.classList.add('active');
            
            if (view === 'table') {
                tableContainer.style.display = 'block';
                graphContainer.style.display = 'none';
            } else if (view === 'graph') {
                tableContainer.style.display = 'none';
                graphContainer.style.display = 'block';
                // Initialize or update the chart
                initializeLineChart();
            }
        });
    });
}

// Line Chart functionality
function initializeLineChart() {
    const canvas = document.getElementById('mcoLineChart');
    if (!canvas) return;
    
    const ctx = canvas.getContext('2d');
    
    // Clear previous chart
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    
    // MCO Data
    const mcoData = [
        { name: 'United', gic: 57.49, ra: 100.00, nonUsers: 0.08 },
        { name: 'Emblem', gic: 54.77, ra: 0.00, nonUsers: 0.00 },
        { name: 'Elderplan', gic: 59.42, ra: 0.00, nonUsers: 0.00 },
        { name: 'Anthem', gic: 50.62, ra: 0.00, nonUsers: 0.00 },
        { name: 'Metroplus', gic: 68.71, ra: 0.00, nonUsers: 48.67 },
        { name: 'Molina', gic: 38.98, ra: 0.00, nonUsers: 17.07 },
        { name: 'Healthfirst', gic: 72.57, ra: 79.26, nonUsers: 15.59 },
        { name: 'Wellcare', gic: 70.87, ra: 3.42, nonUsers: 7.69 }
    ];
    
    // Chart dimensions - full width, proper centering
    const padding = 80;
    const chartWidth = canvas.width - (padding * 2);
    const chartHeight = canvas.height - (padding * 2);
    
    // Draw chart
    drawLineChart(ctx, mcoData, padding, chartWidth, chartHeight);
}

function drawLineChart(ctx, data, padding, width, height) {
    const maxValue = 100;
    const stepX = width / (data.length - 1);
    
    // Colors
    const colors = {
        gic: '#1976d2',
        ra: '#4caf50',
        nonUsers: '#ff9800'
    };
    
    // Draw grid lines
    ctx.strokeStyle = '#e0e0e0';
    ctx.lineWidth = 1;
    
    // Horizontal grid lines
    for (let i = 0; i <= 5; i++) {
        const y = padding + (height / 5) * i;
        ctx.beginPath();
        ctx.moveTo(padding, y);
        ctx.lineTo(padding + width, y);
        ctx.stroke();
    }
    
    // Vertical grid lines
    for (let i = 0; i < data.length; i++) {
        const x = padding + stepX * i;
        ctx.beginPath();
        ctx.moveTo(x, padding);
        ctx.lineTo(x, padding + height);
        ctx.stroke();
    }
    
    // Draw lines for each metric
    const metrics = ['gic', 'ra', 'nonUsers'];
    
    metrics.forEach((metric, metricIndex) => {
        ctx.strokeStyle = colors[metric];
        ctx.lineWidth = 3;
        ctx.lineCap = 'round';
        ctx.lineJoin = 'round';
        ctx.beginPath();
        
        data.forEach((point, index) => {
            const x = padding + stepX * index;
            const y = padding + height - (point[metric] / maxValue) * height;
            
            if (index === 0) {
                ctx.moveTo(x, y);
            } else {
                ctx.lineTo(x, y);
            }
        });
        
        ctx.stroke();
        
        // Draw data points with better visibility
        ctx.fillStyle = colors[metric];
        data.forEach((point, index) => {
            const x = padding + stepX * index;
            const y = padding + height - (point[metric] / maxValue) * height;
            
            // Outer circle (white background)
            ctx.beginPath();
            ctx.arc(x, y, 6, 0, 2 * Math.PI);
            ctx.fillStyle = 'white';
            ctx.fill();
            ctx.strokeStyle = colors[metric];
            ctx.lineWidth = 2;
            ctx.stroke();
            
            // Inner circle (colored)
            ctx.beginPath();
            ctx.arc(x, y, 3, 0, 2 * Math.PI);
            ctx.fillStyle = colors[metric];
            ctx.fill();
        });
    });
    
    // Draw labels
    ctx.fillStyle = '#333';
    ctx.font = 'bold 14px Roboto, sans-serif';
    ctx.textAlign = 'center';
    
    // X-axis labels (MCO names)
    data.forEach((point, index) => {
        const x = padding + stepX * index;
        ctx.fillText(point.name, x, padding + height + 25);
    });
    
    // Y-axis labels
    ctx.font = '12px Roboto, sans-serif';
    ctx.textAlign = 'right';
    for (let i = 0; i <= 5; i++) {
        const y = padding + (height / 5) * i;
        const value = (5 - i) * 20;
        ctx.fillText(value + '%', padding - 15, y + 4);
    }
    
    // Legend - properly centered
    const legendY = padding - 25;
    const legendWidth = 200;
    let legendX = padding + (width - legendWidth) / 2;
    
    metrics.forEach((metric, index) => {
        const metricName = metric === 'gic' ? 'GIC' : metric === 'ra' ? 'RA' : 'NON-USERS';
        
        // Draw legend color with rounded corners
        ctx.fillStyle = colors[metric];
        ctx.fillRect(legendX, legendY - 10, 14, 14);
        
        // Draw legend text
        ctx.fillStyle = '#333';
        ctx.font = 'bold 12px Roboto, sans-serif';
        ctx.textAlign = 'left';
        ctx.fillText(metricName, legendX + 20, legendY);
        
        legendX += 70;
    });
}
