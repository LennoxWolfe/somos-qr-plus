// Approval Module JavaScript functionality

// Verification Request Practices filter modal - define first so onclick works
function openVerificationPracticesFilterModal() {
    var modal = document.getElementById('verificationPracticesFilterModal');
    if (modal) {
        modal.classList.add('show');
        document.body.style.overflow = 'hidden';
    }
}
function closeVerificationPracticesFilterModal() {
    var modal = document.getElementById('verificationPracticesFilterModal');
    if (modal) {
        modal.classList.remove('show');
        document.body.style.overflow = 'auto';
    }
}
window.openVerificationPracticesFilterModal = openVerificationPracticesFilterModal;
window.closeVerificationPracticesFilterModal = closeVerificationPracticesFilterModal;

function openRequestVerificationDialog(rowData) {
    var modal = document.getElementById('requestVerificationModal');
    if (!modal || !rowData) return;
    var idEl = document.getElementById('requestVerificationId');
    var statusEl = document.getElementById('requestVerificationStatus');
    if (idEl) idEl.textContent = rowData.requestId || '';
    if (statusEl) statusEl.textContent = rowData.status || '';
    setFormValue('rvFirstName', rowData.firstName);
    setFormValue('rvLastName', rowData.lastName);
    setFormValue('rvNPI', rowData.npi != null && rowData.npi !== '' ? rowData.npi : '—');
    setFormValue('rvEmail', rowData.email);
    setFormValue('rvPhone', rowData.phone != null && rowData.phone !== '' ? rowData.phone : '—');
    setFormValue('rvProfile', rowData.profile);
    var tbody = document.getElementById('requestVerificationPracticeTbody');
    if (tbody) {
        tbody.innerHTML = '';
        var practices = rowData.practices && rowData.practices.length ? rowData.practices : [{ id: rowData.tin || '—', practiceName: '—', city: '—', tin: rowData.tin || '—' }];
        practices.forEach(function(p) {
            var tr = document.createElement('tr');
            tr.innerHTML = '<td>' + (p.id || '—') + '</td><td>' + (p.practiceName || '—') + '</td><td>' + (p.city || '—') + '</td><td>' + (p.tin || '—') + '</td>';
            tbody.appendChild(tr);
        });
    }
    modal.classList.add('show');
    document.body.style.overflow = 'hidden';
}

function setFormValue(id, value) {
    var el = document.getElementById(id);
    if (el) el.textContent = value != null && value !== '' ? value : '—';
}

function closeRequestVerificationDialog() {
    var modal = document.getElementById('requestVerificationModal');
    if (modal) {
        modal.classList.remove('show');
        document.body.style.overflow = 'auto';
    }
}
window.openRequestVerificationDialog = openRequestVerificationDialog;
window.closeRequestVerificationDialog = closeRequestVerificationDialog;

document.addEventListener('DOMContentLoaded', function() {
    // Initialize interactive elements
    initializeSearchableDropdown();
    initializeNavigation();
    initializeNotifications();
    initializeTabs();
    initializeTables();
    initializeToggleSwitches();
    initializeActionMenus();
    initializeVerificationPracticesFilterModal();
    initializeRequestVerificationModal();
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

    // Profile option clicks
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
    // 2. Update the approval module data
    // 3. Update any other data on the page
    
    console.log('Updating provider data for:', providerText);
    
    // Show loading state
    showLoading();
    
    // Simulate API call
    setTimeout(() => {
        hideLoading();
        showToast('success', 'Data Updated', `Approval module data updated for ${providerText}.`);
        
        // Example of how you might update the approval data
        // updateApprovalData(newData);
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
    showToast('success', 'Notifications Marked Read', 'All notifications have been marked as read.');
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
        showToast('success', 'Notification Removed', 'Notification has been removed.');
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
}

// Table functionality
function initializeTables() {
    // Initialize sorting for all tables
    initializeTableSorting('.invites-table');
    initializeTableSorting('.practices-table');
    initializeTableSorting('.providers-table');
    initializeTableSorting('.verification-practices-table');
    initializeTableSorting('.verification-users-table');
    
    // Initialize pagination
    initializePagination('.invites-table');
    initializePagination('.practices-table');
    initializePagination('.providers-table');
    initializePagination('.verification-practices-table');
    initializePagination('.verification-users-table');
    
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
    const practiceInvitesFilter = document.getElementById('practiceInvitesFilter');
    const tinFilter = document.getElementById('tinFilter');
    const userFilter = document.getElementById('userFilter');
    const npiFilter = document.getElementById('npiFilter');
    const providerUserFilter = document.getElementById('providerUserFilter');
    const practiceCancelationSearch = document.getElementById('practiceCancelationSearch');
    const providerCancelationSearch = document.getElementById('providerCancelationSearch');
    const verificationPracticesFilter = document.getElementById('verificationPracticesFilter');
    const verificationUsersFilter = document.getElementById('verificationUsersFilter');
    
    if (practiceInvitesFilter) {
        practiceInvitesFilter.addEventListener('input', (e) => {
            filterInvitesTable('.invites-table', e.target.value);
        });
    }
    
    if (tinFilter) {
        tinFilter.addEventListener('change', (e) => {
            filterPracticesTable('.practices-table', e.target.value, 'tin');
        });
    }
    
    if (userFilter) {
        userFilter.addEventListener('change', (e) => {
            filterPracticesTable('.practices-table', e.target.value, 'user');
        });
    }
    
    if (practiceCancelationSearch) {
        practiceCancelationSearch.addEventListener('input', (e) => {
            filterPracticesTableBySearch('.practices-table', e.target.value);
        });
    }
    
    if (npiFilter) {
        npiFilter.addEventListener('change', (e) => {
            filterProvidersTable('.providers-table', e.target.value, 'npi');
        });
    }
    
    if (providerUserFilter) {
        providerUserFilter.addEventListener('change', (e) => {
            filterProvidersTable('.providers-table', e.target.value, 'user');
        });
    }
    
    if (providerCancelationSearch) {
        providerCancelationSearch.addEventListener('input', (e) => {
            filterProvidersTableBySearch('.providers-table', e.target.value);
        });
    }
    
    if (verificationPracticesFilter) {
        verificationPracticesFilter.addEventListener('input', (e) => {
            filterInvitesTable('.verification-practices-table', e.target.value);
        });
    }
    
    if (verificationUsersFilter) {
        verificationUsersFilter.addEventListener('input', (e) => {
            filterInvitesTable('.verification-users-table', e.target.value);
        });
    }
}

function filterInvitesTable(tableSelector, searchTerm) {
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

function filterPracticesTable(tableSelector, filterValue, filterType) {
    const table = document.querySelector(tableSelector);
    if (!table) return;
    const tbody = table.querySelector('tbody');
    if (!tbody) return;
    const rows = tbody.querySelectorAll('tr');
    
    rows.forEach(row => {
        if (!filterValue) {
            row.style.display = '';
            return;
        }
        
        let shouldShow = false;
        
        if (filterType === 'tin') {
            const tinCell = row.querySelector('.tin-cell');
            if (tinCell && tinCell.textContent.includes(filterValue)) {
                shouldShow = true;
            }
        } else if (filterType === 'user') {
            const firstNameCell = row.querySelector('.first-name-cell');
            const lastNameCell = row.querySelector('.last-name-cell');
            const fullName = `${firstNameCell?.textContent} ${lastNameCell?.textContent}`.toLowerCase();
            if (fullName.includes(filterValue.toLowerCase())) {
                shouldShow = true;
            }
        }
        
        row.style.display = shouldShow ? '' : 'none';
    });
}

function filterPracticesTableBySearch(tableSelector, searchTerm) {
    const table = document.querySelector(tableSelector);
    if (!table) return;
    const tbody = table.querySelector('tbody');
    if (!tbody) return;
    const rows = tbody.querySelectorAll('tr');
    
    const searchLower = searchTerm.toLowerCase();
    
    rows.forEach(row => {
        if (!searchTerm) {
            row.style.display = '';
            return;
        }
        
        const rowText = row.textContent.toLowerCase();
        row.style.display = rowText.includes(searchLower) ? '' : 'none';
    });
}

function filterProvidersTable(tableSelector, filterValue, filterType) {
    const table = document.querySelector(tableSelector);
    if (!table) return;
    const tbody = table.querySelector('tbody');
    if (!tbody) return;
    const rows = tbody.querySelectorAll('tr');
    
    rows.forEach(row => {
        if (!filterValue) {
            row.style.display = '';
            return;
        }
        
        let shouldShow = false;
        
        if (filterType === 'npi') {
            const npiCell = row.querySelector('.npi-cell');
            if (npiCell && npiCell.textContent.includes(filterValue)) {
                shouldShow = true;
            }
        } else if (filterType === 'user') {
            const providerCell = row.querySelector('.provider-cell');
            if (providerCell && providerCell.textContent.toLowerCase().includes(filterValue.toLowerCase())) {
                shouldShow = true;
            }
        }
        
        row.style.display = shouldShow ? '' : 'none';
    });
}

function filterProvidersTableBySearch(tableSelector, searchTerm) {
    const table = document.querySelector(tableSelector);
    if (!table) return;
    const tbody = table.querySelector('tbody');
    if (!tbody) return;
    const rows = tbody.querySelectorAll('tr');
    
    const searchLower = searchTerm.toLowerCase();
    
    rows.forEach(row => {
        if (!searchTerm) {
            row.style.display = '';
            return;
        }
        
        const rowText = row.textContent.toLowerCase();
        row.style.display = rowText.includes(searchLower) ? '' : 'none';
    });
}

// Toggle switches functionality
function initializeToggleSwitches() {
    const toggleSwitches = document.querySelectorAll('.toggle-switch input');
    
    toggleSwitches.forEach(toggle => {
        toggle.addEventListener('change', function() {
            const inviteId = this.id.split('-')[1];
            const isDelivered = this.checked;
            
            updateEmailDeliveryStatus(inviteId, isDelivered);
        });
    });
}

function updateEmailDeliveryStatus(inviteId, isDelivered) {
    console.log(`Updating email delivery status for invite ${inviteId} to ${isDelivered ? 'delivered' : 'not delivered'}`);
    
    // Show loading state
    showLoading();
    
    // Simulate API call
    setTimeout(() => {
        hideLoading();
        showToast('success', 'Status Updated', `Email delivery status updated for invite ${inviteId}.`);
        
        // In a real implementation, you would:
        // 1. Send the status change to the server
        // 2. Update the database
        // 3. Handle any errors
        // 4. Update any related UI elements
    }, 1000);
}

// Action Menu functionality
function toggleActionMenu(menuId) {
    console.log('toggleActionMenu called with:', menuId);
    // Close all other menus first
    const allMenus = document.querySelectorAll('.action-menu-dropdown');
    allMenus.forEach(menu => {
        if (menu.id !== `actionMenu${menuId}`) {
            menu.classList.remove('show');
        }
    });
    
    // Toggle the clicked menu
    const menu = document.getElementById(`actionMenu${menuId}`);
    console.log('Menu element:', menu);
    if (menu) {
        menu.classList.toggle('show');
        console.log('Menu classes after toggle:', menu.classList.toString());
    } else {
        console.error('Menu not found with ID:', `actionMenu${menuId}`);
    }
}

// Make function globally accessible
window.toggleActionMenu = toggleActionMenu;

// Initialize action menu buttons
function initializeActionMenus() {
    const actionMenuButtons = document.querySelectorAll('.action-menu-btn');
    actionMenuButtons.forEach(button => {
        // Remove existing onclick handlers
        button.removeAttribute('onclick');
        
        // Add event listener
        button.addEventListener('click', function(e) {
            e.stopPropagation();
            e.preventDefault();
            
            // Get the menu ID from the button's parent's dropdown
            const actionMenu = this.closest('.action-menu');
            const dropdown = actionMenu ? actionMenu.querySelector('.action-menu-dropdown') : null;
            
            if (dropdown && dropdown.id) {
                // Extract menuId from ID like "actionMenuProvider1" -> "provider1"
                const menuId = dropdown.id.replace('actionMenu', '');
                console.log('Button clicked, menuId:', menuId);
                toggleActionMenu(menuId);
            }
        });
    });
}

function closeAllActionMenus() {
    document.querySelectorAll('.action-menu-dropdown').forEach(menu => {
        menu.classList.remove('show');
    });
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

// Action button functions
function refreshPracticeInvites() {
    console.log('Refreshing Practice Invites data...');
    showLoading();
    
    setTimeout(() => {
        hideLoading();
        showToast('success', 'Data Refreshed', 'Practice Invites data has been refreshed successfully.');
    }, 1000);
}

function addInvitation() {
    console.log('Opening Add Invitation modal...');
    openAddInvitationModal();
}

function openFilterModal() {
    console.log('Opening filter modal...');
    openFilterModalDialog();
}

function exportToExcel() {
    console.log('Opening Export modal...');
    openExportModal();
}

function uploadInvitations() {
    console.log('Opening Upload modal...');
    openUploadModal();
}

// Verification Request Practices tab
function refreshVerificationPractices() {
    console.log('Refreshing Verification Request Practices data...');
    showLoading();
    setTimeout(() => {
        hideLoading();
        showToast('success', 'Data Refreshed', 'Verification Request Practices data has been refreshed successfully.');
    }, 1000);
}

function exportVerificationPracticesToExcel() {
    console.log('Exporting Verification Request Practices to Excel...');
    showToast('success', 'Export Started', 'Verification Request Practices export has been started.');
}

function initializeVerificationPracticesFilterModal() {
    var modal = document.getElementById('verificationPracticesFilterModal');
    var closeBtn = document.getElementById('closeVerificationPracticesFilterModalBtn');
    var cancelBtn = document.getElementById('verificationPracticesFilterCancelBtn');
    var applyBtn = document.getElementById('verificationPracticesFilterApplyBtn');

    // 1) Direct listener on the VP Filter button (unique class .vp-filter-btn)
    var vpFilterBtn = document.querySelector('.vp-filter-btn');
    if (vpFilterBtn) {
        vpFilterBtn.addEventListener('click', function(e) {
            e.preventDefault();
            e.stopPropagation();
            openVerificationPracticesFilterModal();
        });
    }

    // 2) Capture-phase delegation so we run before any other handler
    document.body.addEventListener('click', function(e) {
        if (e.target && e.target.closest && e.target.closest('.vp-filter-btn')) {
            e.preventDefault();
            e.stopPropagation();
            openVerificationPracticesFilterModal();
        }
    }, true);

    if (closeBtn && modal) {
        closeBtn.addEventListener('click', function() { closeVerificationPracticesFilterModal(); });
    }
    if (cancelBtn && modal) {
        cancelBtn.addEventListener('click', function() { closeVerificationPracticesFilterModal(); });
    }
    if (applyBtn) {
        applyBtn.addEventListener('click', function() { applyVerificationPracticesFilters(); });
    }
    if (modal) {
        modal.addEventListener('click', function(e) {
            if (e.target === modal) closeVerificationPracticesFilterModal();
        });
    }
}

function initializeRequestVerificationModal() {
    var modal = document.getElementById('requestVerificationModal');
    var closeBtn = document.getElementById('closeRequestVerificationModalBtn');
    var cancelBtn = document.getElementById('requestVerificationCancelBtn');
    var denyBtn = document.getElementById('requestVerificationDenyBtn');
    var acceptBtn = document.getElementById('requestVerificationAcceptBtn');

    if (closeBtn && modal) closeBtn.addEventListener('click', closeRequestVerificationDialog);
    if (cancelBtn && modal) cancelBtn.addEventListener('click', closeRequestVerificationDialog);
    if (denyBtn) {
        denyBtn.addEventListener('click', function() {
            closeRequestVerificationDialog();
            showToast('info', 'Request Denied', 'Verification request has been denied.');
        });
    }
    if (acceptBtn) {
        acceptBtn.addEventListener('click', function() {
            closeRequestVerificationDialog();
            showToast('success', 'Request Accepted', 'Verification request has been accepted.');
        });
    }
    if (modal) {
        modal.addEventListener('click', function(e) {
            if (e.target === modal) closeRequestVerificationDialog();
        });
    }
}

function applyVerificationPracticesFilters() {
    const firstName = (document.getElementById('vpFilterFirstName') || {}).value.trim().toLowerCase();
    const lastName = (document.getElementById('vpFilterLastName') || {}).value.trim().toLowerCase();
    const npi = (document.getElementById('vpFilterNPI') || {}).value.trim().toLowerCase();
    const profile = (document.getElementById('vpFilterProfile') || {}).value.trim().toLowerCase();
    const tin = (document.getElementById('vpFilterTIN') || {}).value.trim().toLowerCase();
    const status = (document.getElementById('vpFilterStatus') || {}).value.trim().toLowerCase();

    const table = document.querySelector('.verification-practices-table');
    if (!table) return;
    const rows = table.querySelectorAll('tbody tr');

    rows.forEach(row => {
        const cells = row.querySelectorAll('td');
        if (cells.length < 7) return;
        const rowFirstName = (cells[1].textContent || '').trim().toLowerCase();
        const rowLastName = (cells[2].textContent || '').trim().toLowerCase();
        const rowProfile = (cells[3].textContent || '').trim().toLowerCase();
        const rowTin = (cells[4].textContent || '').trim().toLowerCase();
        const rowStatus = (cells[5].textContent || '').trim().toLowerCase();

        const matchFirstName = !firstName || rowFirstName.includes(firstName);
        const matchLastName = !lastName || rowLastName.includes(lastName);
        const matchProfile = !profile || rowProfile.includes(profile);
        const matchTin = !tin || rowTin.includes(tin);
        const matchStatus = !status || rowStatus.includes(status);
        const matchNpi = !npi || rowTin.includes(npi) || (cells[4].textContent || '').replace(/\D/g, '').includes(npi.replace(/\D/g, ''));

        row.style.display = (matchFirstName && matchLastName && matchProfile && matchTin && matchStatus && matchNpi) ? '' : 'none';
    });

    closeVerificationPracticesFilterModal();
    showToast('success', 'Filters Applied', 'Verification Request Practices filters have been applied.');
}

function viewVerificationRequest(id) {
    console.log('View verification request:', id);
    closeAllActionMenus();
    showToast('info', 'View', 'Verification request details (placeholder).');
}

function approveVerificationRequest(menuId) {
    closeAllActionMenus();
    var menu = document.getElementById('actionMenu' + menuId);
    if (!menu) return;
    var row = menu.closest('tr');
    if (!row) return;
    var cells = row.querySelectorAll('td');
    if (cells.length < 7) return;
    var statusCell = cells[5];
    var statusText = statusCell.querySelector('.status-badge') ? statusCell.querySelector('.status-badge').textContent.trim() : statusCell.textContent.trim();
    var rowData = {
        requestId: '#VF' + (menuId.replace(/^verification/, '') || ''),
        status: statusText || 'Pending',
        email: getCellText(cells[0]),
        firstName: getCellText(cells[1]),
        lastName: getCellText(cells[2]),
        profile: getCellText(cells[3]),
        tin: getCellText(cells[4]),
        npi: '',
        phone: '',
        practices: [{ id: getCellText(cells[4]), practiceName: '—', city: '—', tin: getCellText(cells[4]) }]
    };
    openRequestVerificationDialog(rowData);
}

function getCellText(cell) {
    return cell ? (cell.textContent || '').trim() : '';
}

// Verification Request Users tab
function refreshVerificationUsers() {
    console.log('Refreshing Verification Request Users data...');
    showLoading();
    setTimeout(() => {
        hideLoading();
        showToast('success', 'Data Refreshed', 'Verification Request Users data has been refreshed successfully.');
    }, 1000);
}

function exportVerificationUsersToExcel() {
    console.log('Exporting Verification Request Users to Excel...');
    showToast('success', 'Export Started', 'Verification Request Users export has been started.');
}

function viewVerificationUser(id) {
    console.log('View verification user:', id);
    closeAllActionMenus();
    showToast('info', 'View', 'Verification user details (placeholder).');
}

function approveVerificationUser(id) {
    console.log('Approve verification user:', id);
    closeAllActionMenus();
    showToast('success', 'Approved', 'Verification user has been approved (placeholder).');
}

// Invite action functions
function sendEmail(inviteId) {
    console.log(`Sending email for invite ${inviteId}...`);
    showLoading();
    
    setTimeout(() => {
        hideLoading();
        showToast('success', 'Email Sent', `Email has been sent for invite ${inviteId}.`);
    }, 1000);
}

function viewInvite(inviteId) {
    console.log(`Viewing invite ${inviteId}...`);
    showLoading();
    
    setTimeout(() => {
        hideLoading();
        showToast('info', 'Invite Details', `Invite ${inviteId} details have been loaded.`);
    }, 1000);
}

function deleteInvite(inviteId) {
    console.log(`Deleting invite ${inviteId}...`);
    showLoading();
    
    setTimeout(() => {
        hideLoading();
        showToast('success', 'Invite Deleted', `Invite ${inviteId} has been deleted successfully.`);
    }, 1000);
}

// Practice action functions
function viewPractice(practiceId) {
    console.log(`Viewing practice ${practiceId}...`);
    showLoading();
    
    setTimeout(() => {
        hideLoading();
        showToast('info', 'Practice Details', `Practice ${practiceId} details have been loaded.`);
    }, 1000);
}

function disenrollPractice(practiceId) {
    console.log(`Disenrolling practice ${practiceId}...`);
    showLoading();
    
    setTimeout(() => {
        hideLoading();
        showToast('success', 'Practice Disenrolled', `Practice ${practiceId} has been disenrolled successfully.`);
    }, 1000);
}

function retractPracticeCancellation(practiceId) {
    console.log(`Retracting cancellation for practice ${practiceId}...`);
    showLoading();
    
    setTimeout(() => {
        hideLoading();
        showToast('success', 'Cancellation Retracted', `Cancellation has been retracted for practice ${practiceId} successfully.`);
    }, 1000);
}

// Provider action functions
function viewProvider(providerId) {
    console.log(`Viewing provider ${providerId}...`);
    showLoading();
    
    setTimeout(() => {
        hideLoading();
        showToast('info', 'Provider Details', `Provider ${providerId} details have been loaded.`);
    }, 1000);
}

function disenrollProvider(providerId) {
    console.log(`Disenrolling provider ${providerId}...`);
    showLoading();
    
    setTimeout(() => {
        hideLoading();
        showToast('success', 'Provider Disenrolled', `Provider ${providerId} has been disenrolled successfully.`);
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
    showToast('error', 'Error', message);
}

// Modal Functions
function openAddInvitationModal() {
    const modal = document.getElementById('addInvitationModal');
    if (modal) {
        modal.classList.add('show');
        document.body.style.overflow = 'hidden';
        initializePracticeInvitationForm();
    }
}

function closeAddInvitationModal() {
    const modal = document.getElementById('addInvitationModal');
    if (modal) {
        modal.classList.remove('show');
        document.body.style.overflow = 'auto';
        // Clear form
        document.getElementById('addInvitationForm').reset();
        clearFormErrors();
    }
}

// Initialize form validation on modal open
function initializePracticeInvitationForm() {
    const modal = document.getElementById('addInvitationModal');
    if (!modal) return;
    
    // Add real-time validation
    const emailInput = document.getElementById('inviteEmail');
    const firstNameInput = document.getElementById('inviteFirstName');
    const lastNameInput = document.getElementById('inviteLastName');
    const phoneInput = document.getElementById('phoneNumber');
    
    if (emailInput) {
        emailInput.addEventListener('blur', validateEmailField);
        emailInput.addEventListener('input', clearFieldError);
    }
    
    if (firstNameInput) {
        firstNameInput.addEventListener('blur', validateRequiredField);
        firstNameInput.addEventListener('input', clearFieldError);
    }
    
    if (lastNameInput) {
        lastNameInput.addEventListener('blur', validateRequiredField);
        lastNameInput.addEventListener('input', clearFieldError);
    }
    
    if (phoneInput) {
        phoneInput.addEventListener('blur', validatePhoneField);
        phoneInput.addEventListener('input', clearFieldError);
        phoneInput.addEventListener('input', formatPhoneNumber);
    }
}

function validateEmailField(event) {
    const input = event.target;
    const errorElement = document.getElementById('emailError');
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    
    if (!input.value.trim()) {
        input.classList.add('error');
        errorElement.textContent = 'Email is required';
        errorElement.classList.add('show');
    } else if (!emailRegex.test(input.value.trim())) {
        input.classList.add('error');
        errorElement.textContent = 'Please enter a valid email address';
        errorElement.classList.add('show');
    } else {
        input.classList.remove('error');
        errorElement.classList.remove('show');
    }
}

function validateRequiredField(event) {
    const input = event.target;
    const fieldName = input.id.replace('invite', '').replace('Name', ' Name').replace('Email', 'Email');
    const errorElement = document.getElementById(input.id.replace('invite', '').toLowerCase() + 'Error');
    
    if (!input.value.trim()) {
        input.classList.add('error');
        errorElement.textContent = `${fieldName} is required`;
        errorElement.classList.add('show');
    } else {
        input.classList.remove('error');
        errorElement.classList.remove('show');
    }
}

function validatePhoneField(event) {
    const input = event.target;
    const errorElement = document.getElementById('phoneError');
    const phoneRegex = /^\d{3}-\d{3}-\d{4}$/;
    
    if (!input.value.trim()) {
        input.classList.add('error');
        errorElement.textContent = 'Phone Number is required';
        errorElement.classList.add('show');
    } else if (!phoneRegex.test(input.value.trim())) {
        input.classList.add('error');
        errorElement.textContent = 'Please enter phone number in format 999-999-9999';
        errorElement.classList.add('show');
    } else {
        input.classList.remove('error');
        errorElement.classList.remove('show');
    }
}

function clearFieldError(event) {
    const input = event.target;
    const errorElement = document.getElementById(input.id.replace('invite', '').toLowerCase() + 'Error');
    
    if (input.value.trim()) {
        input.classList.remove('error');
        if (errorElement) {
            errorElement.classList.remove('show');
        }
    }
}

function formatPhoneNumber(event) {
    const input = event.target;
    let value = input.value.replace(/\D/g, ''); // Remove non-digits
    
    if (value.length >= 6) {
        value = value.substring(0, 3) + '-' + value.substring(3, 6) + '-' + value.substring(6, 10);
    } else if (value.length >= 3) {
        value = value.substring(0, 3) + '-' + value.substring(3);
    }
    
    input.value = value;
}

function submitAddInvitation() {
    const form = document.getElementById('addInvitationForm');
    const formData = new FormData(form);
    
    // Clear previous errors
    clearFormErrors();
    
    // Validate form
    const isValid = validatePracticeInvitationForm();
    if (!isValid) {
        showToast('error', 'Validation Error', 'Please fill in all required fields correctly.');
        return;
    }
    
    showLoading();
    
    setTimeout(() => {
        hideLoading();
        closeAddInvitationModal();
        showToast('success', 'Invitation Saved', 'Practice invitation has been saved successfully.');
        
        // In a real implementation, you would send the data to the server
        console.log('Form data:', Object.fromEntries(formData));
    }, 1000);
}

function validatePracticeInvitationForm() {
    let isValid = true;
    
    // Required fields validation
    const requiredFields = [
        { id: 'inviteEmail', errorId: 'emailError', message: 'Email is required' },
        { id: 'inviteFirstName', errorId: 'firstNameError', message: 'First Name is required' },
        { id: 'inviteLastName', errorId: 'lastNameError', message: 'Last Name is required' },
        { id: 'phoneNumber', errorId: 'phoneError', message: 'Phone Number is required' }
    ];
    
    requiredFields.forEach(field => {
        const input = document.getElementById(field.id);
        const errorElement = document.getElementById(field.errorId);
        
        if (!input.value.trim()) {
            input.classList.add('error');
            errorElement.textContent = field.message;
            errorElement.classList.add('show');
            isValid = false;
        } else {
            input.classList.remove('error');
            errorElement.classList.remove('show');
        }
    });
    
    // Email format validation
    const emailInput = document.getElementById('inviteEmail');
    const emailError = document.getElementById('emailError');
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    
    if (emailInput.value.trim() && !emailRegex.test(emailInput.value.trim())) {
        emailInput.classList.add('error');
        emailError.textContent = 'Please enter a valid email address';
        emailError.classList.add('show');
        isValid = false;
    }
    
    // Phone format validation
    const phoneInput = document.getElementById('phoneNumber');
    const phoneError = document.getElementById('phoneError');
    const phoneRegex = /^\d{3}-\d{3}-\d{4}$/;
    
    if (phoneInput.value.trim() && !phoneRegex.test(phoneInput.value.trim())) {
        phoneInput.classList.add('error');
        phoneError.textContent = 'Please enter phone number in format 999-999-9999';
        phoneError.classList.add('show');
        isValid = false;
    }
    
    return isValid;
}

function clearFormErrors() {
    const errorMessages = document.querySelectorAll('.error-message');
    const errorInputs = document.querySelectorAll('.form-group input.error, .form-group select.error');
    
    errorMessages.forEach(error => {
        error.classList.remove('show');
    });
    
    errorInputs.forEach(input => {
        input.classList.remove('error');
    });
}

function addUsers() {
    console.log('Adding users...');
    showToast('info', 'Add Users', 'Add Users functionality will be implemented.');
}

function addProvider() {
    console.log('Adding provider...');
    showToast('info', 'Add Provider', 'Add Provider functionality will be implemented.');
}

function openFilterModalDialog() {
    const modal = document.getElementById('filterModal');
    if (modal) {
        modal.classList.add('show');
        document.body.style.overflow = 'hidden';
    }
}

function closeFilterModal() {
    const modal = document.getElementById('filterModal');
    if (modal) {
        modal.classList.remove('show');
        document.body.style.overflow = 'auto';
    }
}

function clearFilterField(fieldId) {
    const field = document.getElementById(fieldId);
    if (field) {
        field.value = '';
        field.focus();
    }
}

function applyFilters() {
    const form = document.getElementById('filterForm');
    const formData = new FormData(form);
    
    showLoading();
    
    setTimeout(() => {
        hideLoading();
        closeFilterModal();
        showToast('success', 'Filters Applied', 'Filters have been applied successfully.');
        
        // Apply filters to the practice invites table
        applyPracticeInvitesFilters(Object.fromEntries(formData));
        
        // In a real implementation, you would apply the filters to the table
        console.log('Filter data:', Object.fromEntries(formData));
    }, 1000);
}

function applyPracticeInvitesFilters(filterData) {
    const table = document.querySelector('.invites-table');
    const tbody = table.querySelector('tbody');
    const rows = tbody.querySelectorAll('tr');
    
    rows.forEach(row => {
        let shouldShow = true;
        
        // First Name filter
        if (filterData.firstName) {
            const firstNameCell = row.querySelector('.first-name-cell');
            if (firstNameCell && !firstNameCell.textContent.toLowerCase().includes(filterData.firstName.toLowerCase())) {
                shouldShow = false;
            }
        }
        
        // Last Name filter
        if (filterData.lastName) {
            const lastNameCell = row.querySelector('.last-name-cell');
            if (lastNameCell && !lastNameCell.textContent.toLowerCase().includes(filterData.lastName.toLowerCase())) {
                shouldShow = false;
            }
        }
        
        // Email filter
        if (filterData.email) {
            const emailCell = row.querySelector('.email-cell');
            if (emailCell && !emailCell.textContent.toLowerCase().includes(filterData.email.toLowerCase())) {
                shouldShow = false;
            }
        }
        
        // NPI filter
        if (filterData.npi) {
            const npiCell = row.querySelector('.npi-cell');
            if (npiCell && !npiCell.textContent.includes(filterData.npi)) {
                shouldShow = false;
            }
        }
        
        // TIN filter (would need to be added to table data)
        if (filterData.tin) {
            // This would require TIN data in the table
            // For now, we'll skip this filter
        }
        
        // Status filter
        if (filterData.status) {
            const statusCell = row.querySelector('.status-cell');
            if (statusCell) {
                const statusBadge = statusCell.querySelector('.status-badge');
                if (statusBadge && !statusBadge.textContent.toLowerCase().includes(filterData.status.toLowerCase())) {
                    shouldShow = false;
                }
            }
        }
        
        // Email Delivered filter
        if (filterData.emailDelivered !== undefined) {
            const emailDeliveredCell = row.querySelector('.email-delivered-cell');
            if (emailDeliveredCell) {
                const toggleSwitch = emailDeliveredCell.querySelector('input[type="checkbox"]');
                if (toggleSwitch) {
                    const isChecked = toggleSwitch.checked;
                    const filterValue = filterData.emailDelivered === 'on' || filterData.emailDelivered === true;
                    if (isChecked !== filterValue) {
                        shouldShow = false;
                    }
                }
            }
        }
        
        row.style.display = shouldShow ? '' : 'none';
    });
}

function openExportModal() {
    const modal = document.getElementById('exportModal');
    if (modal) {
        modal.classList.add('show');
        document.body.style.overflow = 'hidden';
    }
}

function closeExportModal() {
    const modal = document.getElementById('exportModal');
    if (modal) {
        modal.classList.remove('show');
        document.body.style.overflow = 'auto';
    }
}

function confirmExport() {
    const format = document.getElementById('exportFormat').value;
    const range = document.getElementById('exportRange').value;
    const includeHeaders = document.getElementById('includeHeaders').checked;
    
    showLoading();
    
    setTimeout(() => {
        hideLoading();
        closeExportModal();
        showToast('success', 'Export Complete', `Data exported as ${format.toUpperCase()} successfully.`);
        
        // In a real implementation, you would trigger the actual export
        console.log('Export options:', { format, range, includeHeaders });
    }, 1500);
}

function openUploadModal() {
    const modal = document.getElementById('uploadModal');
    if (modal) {
        modal.classList.add('show');
        document.body.style.overflow = 'hidden';
        initializeFileUpload();
    }
}

function closeUploadModal() {
    const modal = document.getElementById('uploadModal');
    if (modal) {
        modal.classList.remove('show');
        document.body.style.overflow = 'auto';
        resetUploadArea();
    }
}

function initializeFileUpload() {
    const fileInput = document.getElementById('fileInput');
    const fileStatus = document.getElementById('fileStatus');
    const processBtn = document.getElementById('processBtn');
    
    // File input change handler
    fileInput.addEventListener('change', handleFileSelect);
}

function handleFileSelect(event) {
    const file = event.target.files[0];
    if (file) {
        processSelectedFile(file);
    }
}

function processSelectedFile(file) {
    // Validate file type
    const allowedTypes = ['.xlsx', '.csv'];
    const fileExtension = '.' + file.name.split('.').pop().toLowerCase();
    
    if (!allowedTypes.includes(fileExtension)) {
        showToast('error', 'Invalid File Type', 'Please select an Excel (.xlsx) or CSV (.csv) file.');
        return;
    }
    
    // Validate file size (10MB limit)
    if (file.size > 10 * 1024 * 1024) {
        showToast('error', 'File Too Large', 'File size must be less than 10MB.');
        return;
    }
    
    // Update file status
    document.getElementById('fileStatus').textContent = file.name;
    
    // Show data preview
    showDataPreview(file);
    
    // Enable process button
    document.getElementById('processBtn').disabled = false;
    
    showToast('success', 'File Selected', `${file.name} has been selected for upload.`);
}

function showDataPreview(file) {
    const previewSection = document.getElementById('dataPreviewSection');
    const previewData = document.getElementById('previewData');
    
    // Show preview section
    previewSection.style.display = 'block';
    
    // Generate sample preview data
    const sampleData = [
        { id: '001', comment: 'Valid invitation data' },
        { id: '002', comment: 'Missing email address' },
        { id: '003', comment: 'Invalid phone format' },
        { id: '004', comment: 'Valid invitation data' },
        { id: '005', comment: 'Duplicate NPI number' }
    ];
    
    // Clear existing preview data
    previewData.innerHTML = '';
    
    // Add preview rows
    sampleData.forEach((row, index) => {
        const rowElement = document.createElement('div');
        rowElement.className = 'preview-row';
        rowElement.innerHTML = `
            <div class="preview-row-checkbox">
                <input type="checkbox" id="row-${index}" onchange="updateRowSelection()">
            </div>
            <div class="preview-row-data">
                <div class="preview-cell">${row.id}</div>
                <div class="preview-cell">${row.comment}</div>
            </div>
        `;
        previewData.appendChild(rowElement);
    });
}

function toggleAllRows() {
    const selectAllCheckbox = document.getElementById('selectAllRows');
    const rowCheckboxes = document.querySelectorAll('.preview-row-checkbox input[type="checkbox"]');
    
    rowCheckboxes.forEach(checkbox => {
        checkbox.checked = selectAllCheckbox.checked;
    });
}

function updateRowSelection() {
    const rowCheckboxes = document.querySelectorAll('.preview-row-checkbox input[type="checkbox"]');
    const selectAllCheckbox = document.getElementById('selectAllRows');
    
    const checkedCount = Array.from(rowCheckboxes).filter(cb => cb.checked).length;
    const totalCount = rowCheckboxes.length;
    
    selectAllCheckbox.checked = checkedCount === totalCount;
    selectAllCheckbox.indeterminate = checkedCount > 0 && checkedCount < totalCount;
}

function downloadTemplate() {
    showLoading();
    
    setTimeout(() => {
        hideLoading();
        showToast('success', 'Template Downloaded', 'Practice invitation template has been downloaded.');
        
        // In a real implementation, you would trigger a file download
        console.log('Downloading template...');
    }, 1000);
}

function processUpload() {
    const fileInput = document.getElementById('fileInput');
    const file = fileInput.files[0];
    
    if (!file) {
        showToast('error', 'No File Selected', 'Please select a file to process.');
        return;
    }
    
    // Get selected rows
    const selectedRows = Array.from(document.querySelectorAll('.preview-row-checkbox input[type="checkbox"]:checked'));
    
    if (selectedRows.length === 0) {
        showToast('error', 'No Rows Selected', 'Please select at least one row to process.');
        return;
    }
    
    showLoading();
    
    setTimeout(() => {
        hideLoading();
        closeUploadModal();
        showToast('success', 'Upload Processed', `${selectedRows.length} rows from ${file.name} have been processed successfully.`);
        
        // In a real implementation, you would process the selected rows
        console.log('Processing upload:', file.name, selectedRows.length, 'rows');
    }, 2000);
}

function resetUploadArea() {
    document.getElementById('fileInput').value = '';
    document.getElementById('fileStatus').textContent = 'No file chosen';
    document.getElementById('dataPreviewSection').style.display = 'none';
    document.getElementById('processBtn').disabled = true;
}

// Toast Notification System
function showToast(type, title, message) {
    const toastContainer = document.getElementById('toastContainer');
    if (!toastContainer) return;
    
    const toast = document.createElement('div');
    toast.className = `toast ${type}`;
    
    const icon = getToastIcon(type);
    
    toast.innerHTML = `
        <div class="toast-icon">${icon}</div>
        <div class="toast-content">
            <div class="toast-title">${title}</div>
            <div class="toast-message">${message}</div>
        </div>
        <button class="toast-close" onclick="removeToast(this)">×</button>
    `;
    
    toastContainer.appendChild(toast);
    
    // Auto-remove after 5 seconds
    setTimeout(() => {
        if (toast.parentNode) {
            removeToast(toast.querySelector('.toast-close'));
        }
    }, 5000);
}

function getToastIcon(type) {
    const icons = {
        success: '✓',
        error: '✕',
        warning: '⚠',
        info: 'ℹ'
    };
    return icons[type] || icons.info;
}

function removeToast(closeBtn) {
    const toast = closeBtn.closest('.toast');
    if (toast) {
        toast.style.animation = 'toastSlideOut 0.3s ease-in';
        setTimeout(() => {
            if (toast.parentNode) {
                toast.parentNode.removeChild(toast);
            }
        }, 300);
    }
}

// Add CSS animation for toast removal
const style = document.createElement('style');
style.textContent = `
    @keyframes toastSlideOut {
        from {
            transform: translateX(0);
            opacity: 1;
        }
        to {
            transform: translateX(100%);
            opacity: 0;
        }
    }
`;
document.head.appendChild(style);

// Close modals when clicking outside
document.addEventListener('click', function(e) {
    if (e.target.classList.contains('modal-overlay')) {
        const modal = e.target;
        modal.classList.remove('show');
        document.body.style.overflow = 'auto';
    }
});

// Close modals on escape key
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        const openModal = document.querySelector('.modal-overlay.show');
        if (openModal) {
            openModal.classList.remove('show');
            document.body.style.overflow = 'auto';
        }
    }
});

// Success notification (legacy - keeping for compatibility)
function showSuccess(message) {
    showToast('success', 'Success', message);
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
