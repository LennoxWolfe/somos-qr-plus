// Entity Info Check page

document.addEventListener('DOMContentLoaded', function() {
    initializeSearchableDropdown();
    initializeNavigation();
    initializeNotifications();
    initializeEntityTypeDropdown();
    initTroubleshooting();
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

function showToast(type, title, message) {
    var container = document.getElementById('toastContainer');
    if (!container) return;
    var toast = document.createElement('div');
    toast.className = 'toast ' + (type || 'info');
    toast.innerHTML = '<div class="toast-content"><div class="toast-title">' + (title || '') + '</div><div class="toast-message">' + (message || '') + '</div></div><button class="toast-close">×</button>';
    container.appendChild(toast);
    toast.querySelector('.toast-close').addEventListener('click', function() {
        toast.remove();
    });
    setTimeout(function() {
        if (toast.parentNode) toast.remove();
    }, 5000);
}

function initializeEntityTypeDropdown() {
    var trigger = document.getElementById('entityTypeTrigger');
    var menu = document.getElementById('entityTypeMenu');
    var selectedEl = document.getElementById('entityTypeSelected');
    var searchInput = document.getElementById('entityTypeSearch');
    var options = document.querySelectorAll('.entity-type-option');
    if (!trigger || !menu) return;

    trigger.addEventListener('click', function(e) {
        e.stopPropagation();
        var isOpen = !menu.hidden;
        if (isOpen) {
            menu.hidden = true;
            trigger.setAttribute('aria-expanded', 'false');
        } else {
            menu.hidden = false;
            trigger.setAttribute('aria-expanded', 'true');
            if (searchInput) { searchInput.value = ''; searchInput.focus(); }
            options.forEach(function(o) { o.classList.remove('hidden'); });
        }
    });

    document.addEventListener('click', function(e) {
        var dd = document.getElementById('entityTypeDropdown');
        if (dd && !dd.contains(e.target)) {
            menu.hidden = true;
            trigger.setAttribute('aria-expanded', 'false');
        }
    });

    if (searchInput) {
        searchInput.addEventListener('input', function() {
            var q = searchInput.value.toLowerCase();
            options.forEach(function(opt) {
                var text = (opt.textContent || '').toLowerCase();
                opt.classList.toggle('hidden', q && !text.includes(q));
            });
        });
    }

    options.forEach(function(option) {
        option.addEventListener('click', function() {
            var text = option.textContent.trim();
            var value = option.getAttribute('data-value');
            if (selectedEl) selectedEl.textContent = text;
            selectedEl.setAttribute('data-value', value || '');
            menu.hidden = true;
            trigger.setAttribute('aria-expanded', 'false');
        });
    });
}

function initTroubleshooting() {
    var btn = document.getElementById('troubleshootingBtn');
    if (!btn) return;
    btn.addEventListener('click', function() {
        var entityType = (document.getElementById('entityTypeSelected') || {}).getAttribute('data-value') || (document.getElementById('entityTypeSelected') || {}).textContent || '';
        var value = (document.getElementById('entityValueInput') || {}).value || '';
        console.log('Troubleshooting', { entityType: entityType, value: value });
        showToast('info', 'Troubleshooting', 'Troubleshooting started for ' + (entityType || 'entity') + (value ? ': ' + value : ''));
    });
}
