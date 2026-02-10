// Data Summary page

document.addEventListener('DOMContentLoaded', function() {
    initializeSearchableDropdown();
    initializeNavigation();
    initializeNotifications();
    initializeDataSummarySearch();
    initializePeriodControls();
    initializeDataSummaryTableSort();
    initializeDataSummaryPagination();
});

function closeDrawer() {
    var navDrawer = document.getElementById('navDrawer');
    var drawerOverlay = document.getElementById('drawerOverlay');
    if (navDrawer) navDrawer.classList.remove('open');
    if (drawerOverlay) drawerOverlay.classList.remove('active');
    document.body.style.overflow = 'auto';
}

function initializeNavigation() {
    var menuBtn = document.querySelector('.nav-menu-btn');
    var profileBtn = document.querySelector('.profile-btn');
    var navDrawer = document.getElementById('navDrawer');
    var drawerOverlay = document.getElementById('drawerOverlay');

    if (menuBtn && navDrawer && drawerOverlay) {
        menuBtn.addEventListener('click', function() {
            navDrawer.classList.add('open');
            drawerOverlay.classList.add('active');
            document.body.style.overflow = 'hidden';
        });
    }
    if (drawerOverlay) drawerOverlay.addEventListener('click', closeDrawer);
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape' && navDrawer && navDrawer.classList.contains('open')) closeDrawer();
    });

    var drawerItems = document.querySelectorAll('.drawer-item');
    drawerItems.forEach(function(item) {
        item.addEventListener('click', function() {
            closeDrawer();
        });
    });

    if (profileBtn) {
        profileBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            toggleProfileDropdown();
        });
    }
    document.addEventListener('click', function(e) {
        var profileDropdown = document.getElementById('profileDropdown');
        if (profileDropdown && profileBtn && !profileDropdown.contains(e.target) && !profileBtn.contains(e.target)) {
            closeProfileDropdown();
        }
    });
    var profileOptions = document.querySelectorAll('.profile-option');
    profileOptions.forEach(function(option) {
        option.addEventListener('click', function() {
            var action = option.getAttribute('data-action');
            closeProfileDropdown();
            if (action === 'account-settings') window.location.href = 'account-settings.html';
            else if (action === 'invitations') window.location.href = 'invitation.html';
            else if (action === 'logout') showLogoutDialog();
        });
    });
}

function toggleProfileDropdown() {
    var profileDropdown = document.getElementById('profileDropdown');
    if (!profileDropdown) return;
    if (profileDropdown.classList.contains('show')) {
        closeProfileDropdown();
    } else {
        profileDropdown.classList.add('show');
    }
}

function closeProfileDropdown() {
    var profileDropdown = document.getElementById('profileDropdown');
    if (profileDropdown) profileDropdown.classList.remove('show');
}

function initializeSearchableDropdown() {
    var dropdown = document.getElementById('searchableDropdown');
    var trigger = document.getElementById('dropdownTrigger');
    var menu = document.getElementById('dropdownMenu');
    var searchInput = document.getElementById('searchInput');
    var selectedText = document.getElementById('selectedText');
    var options = document.querySelectorAll('#dropdownOptions .dropdown-option');
    if (!trigger || !menu) return;

    var isOpen = false;
    trigger.addEventListener('click', function(e) {
        e.stopPropagation();
        isOpen = !isOpen;
        if (isOpen) {
            menu.classList.add('show');
            trigger.classList.add('active');
            if (searchInput) searchInput.focus();
        } else {
            menu.classList.remove('show');
            trigger.classList.remove('active');
        }
    });
    document.addEventListener('click', function(e) {
        if (dropdown && !dropdown.contains(e.target)) {
            isOpen = false;
            menu.classList.remove('show');
            trigger.classList.remove('active');
        }
    });
    if (searchInput) {
        searchInput.addEventListener('input', function() {
            var q = searchInput.value.toLowerCase();
            options.forEach(function(opt) {
                var text = (opt.querySelector('.option-text') || {}).textContent || '';
                opt.classList.toggle('hidden', !text.toLowerCase().includes(q));
            });
        });
    }
    options.forEach(function(option) {
        option.addEventListener('click', function(e) {
            e.preventDefault();
            var value = option.getAttribute('data-value');
            var text = (option.querySelector('.option-text') || {}).textContent || '';
            if (selectedText) selectedText.textContent = text;
            options.forEach(function(o) {
                o.classList.remove('selected');
                o.setAttribute('data-selected', 'false');
            });
            option.classList.add('selected');
            option.setAttribute('data-selected', 'true');
            isOpen = false;
            menu.classList.remove('show');
            trigger.classList.remove('active');
        });
    });
}

function initializeNotifications() {
    var notificationBtn = document.getElementById('notificationBtn');
    var notificationsDropdown = document.getElementById('notificationsDropdown');
    if (!notificationBtn || !notificationsDropdown) return;
    notificationBtn.addEventListener('click', function(e) {
        e.stopPropagation();
        notificationsDropdown.classList.toggle('show');
    });
    document.addEventListener('click', function(e) {
        if (!notificationBtn.contains(e.target) && !notificationsDropdown.contains(e.target)) {
            notificationsDropdown.classList.remove('show');
        }
    });
}

function showLogoutDialog() {
    var d = document.getElementById('logoutDialog');
    if (d) { d.classList.add('show'); document.body.style.overflow = 'hidden'; }
}

function closeLogoutDialog() {
    var d = document.getElementById('logoutDialog');
    if (d) { d.classList.remove('show'); document.body.style.overflow = 'auto'; }
}

function confirmLogout() {
    window.location.href = 'login.html';
}

function logout() {
    showLogoutDialog();
}

function initializeDataSummarySearch() {
    var searchInput = document.getElementById('dataSummarySearch');
    var table = document.querySelector('.data-summary-table');
    if (!searchInput || !table) return;
    var tbody = table.querySelector('tbody');
    if (!tbody) return;

    searchInput.addEventListener('input', function() {
        var q = (searchInput.value || '').trim().toLowerCase();
        var rows = tbody.querySelectorAll('tr');
        rows.forEach(function(row) {
            var text = (row.textContent || '').toLowerCase();
            row.style.display = !q || text.indexOf(q) !== -1 ? '' : 'none';
        });
    });
}

function initializePeriodControls() {
    var periodInput = document.getElementById('dataSummaryPeriod');
    var clearBtn = document.getElementById('periodClearBtn');
    var calendarBtn = document.getElementById('periodCalendarBtn');

    if (clearBtn && periodInput) {
        clearBtn.addEventListener('click', function() {
            periodInput.value = '';
            periodInput.focus();
        });
    }
    if (calendarBtn && periodInput) {
        calendarBtn.addEventListener('click', function() {
            periodInput.focus();
        });
    }
}

function initializeDataSummaryTableSort() {
    var table = document.querySelector('.data-summary-table');
    if (!table) return;
    var headers = table.querySelectorAll('thead th.sortable');
    var tbody = table.querySelector('tbody');

    headers.forEach(function(th) {
        th.addEventListener('click', function() {
            var col = th.getAttribute('data-column');
            var currentDir = th.getAttribute('data-sort') || '';
            var dir = currentDir === 'asc' ? 'desc' : 'asc';

            headers.forEach(function(h) {
                h.removeAttribute('data-sort');
                var arrows = h.querySelector('.sort-arrows');
                if (arrows) arrows.textContent = '↕';
            });
            th.setAttribute('data-sort', dir);
            var arrows = th.querySelector('.sort-arrows');
            if (arrows) arrows.textContent = dir === 'asc' ? '↑' : '↓';

            var rows = Array.from(tbody.querySelectorAll('tr'));
            var colIndex = Array.prototype.indexOf.call(table.querySelectorAll('thead th'), th);

            rows.sort(function(a, b) {
                var aCell = a.cells[colIndex];
                var bCell = b.cells[colIndex];
                var aVal = (aCell ? aCell.textContent : '').trim();
                var bVal = (bCell ? bCell.textContent : '').trim();
                var aNum = parseFloat(aVal.replace(/,/g, ''), 10);
                var bNum = parseFloat(bVal.replace(/,/g, ''), 10);
                if (!isNaN(aNum) && !isNaN(bNum)) {
                    return dir === 'asc' ? aNum - bNum : bNum - aNum;
                }
                if (dir === 'asc') return aVal > bVal ? 1 : aVal < bVal ? -1 : 0;
                return aVal < bVal ? 1 : aVal > bVal ? -1 : 0;
            });

            rows.forEach(function(row) {
                tbody.appendChild(row);
            });
        });
    });
}

function initializeDataSummaryPagination() {
    var container = document.querySelector('.data-summary-container');
    if (!container) return;
    var pagination = container.querySelector('.pagination');
    if (!pagination) return;
    var btns = pagination.querySelectorAll('.pagination-btn');

    btns.forEach(function(btn) {
        btn.addEventListener('click', function() {
            if (btn.disabled) return;
            btns.forEach(function(b) {
                b.classList.remove('active');
            });
            btn.classList.add('active');
        });
    });
}
