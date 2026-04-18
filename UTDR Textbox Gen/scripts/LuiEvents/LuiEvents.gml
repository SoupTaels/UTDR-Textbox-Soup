#macro LUI_EV_CREATE "create" // Triggered after the element is added to a parent
#macro LUI_EV_DESTROY "destroy" // Called when the element is deleted, e.g., to clean up resources
#macro LUI_EV_CONTENT_UPDATE "content_update" // Triggered when elements are added or removed inside
#macro LUI_EV_MOUSE_LEFT "mouse_left" // Triggered while the left mouse button is held on the element
#macro LUI_EV_MOUSE_LEFT_PRESSED "mouse_left_pressed" // Triggered once when the left mouse button is pressed
#macro LUI_EV_MOUSE_LEFT_RELEASED "mouse_left_released" // Triggered once when the left mouse button is released
#macro LUI_EV_MOUSE_WHEEL "mouse_wheel" // Triggered when the mouse wheel is scrolled
#macro LUI_EV_MOUSE_ENTER "mouse_enter" // Triggered once when the mouse enters the element
#macro LUI_EV_MOUSE_LEAVE "mouse_leave" // Triggered once when the mouse leaves the element
#macro LUI_EV_KEYBOARD_INPUT "keyboard_input" // Triggered during keyboard input when the element is focused
#macro LUI_EV_KEYBOARD_RELEASE "keyboard_release" // Triggered when a keyboard key is released while focused
#macro LUI_EV_POSITION_UPDATE "position_update" // Triggered when the element changes its position
#macro LUI_EV_FOCUS_SET "focus_set" // Triggered once when the element gains focus
#macro LUI_EV_FOCUS_REMOVE "focus_remove" // Triggered once when the element loses focus
#macro LUI_EV_VALUE_UPDATE "value_update" // Triggered when the element's value changes
#macro LUI_EV_SHOW "show" // Triggered when the element becomes visible
#macro LUI_EV_HIDE "hide" // Triggered when the element becomes invisible
#macro LUI_EV_SIZE_UPDATE "size_update" // Triggered when the element changes its size
#macro LUI_EV_DRAGGING "dragging" // Triggered while the element is being dragged (returns the structure with the new coordinates of the element or mouse)
#macro LUI_EV_DRAG_START "drag_start" // Triggered once when dragging starts
#macro LUI_EV_DRAG_END "drag_end" // Triggered once when dragging ends
#macro LUI_EV_CLICK "click" // Triggered when the element is clicked (full press-release cycle)