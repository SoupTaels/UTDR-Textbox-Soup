/************************************************************************************************
███████╗██╗  ██╗██████╗ ███████╗██████╗ ██╗███╗   ███╗███████╗███╗   ██╗████████╗ █████╗ ██╗     
██╔════╝╚██╗██╔╝██╔══██╗██╔════╝██╔══██╗██║████╗ ████║██╔════╝████╗  ██║╚══██╔══╝██╔══██╗██║     
█████╗   ╚███╔╝ ██████╔╝█████╗  ██████╔╝██║██╔████╔██║█████╗  ██╔██╗ ██║   ██║   ███████║██║     
██╔══╝   ██╔██╗ ██╔═══╝ ██╔══╝  ██╔══██╗██║██║╚██╔╝██║██╔══╝  ██║╚██╗██║   ██║   ██╔══██║██║     
███████╗██╔╝ ██╗██║     ███████╗██║  ██║██║██║ ╚═╝ ██║███████╗██║ ╚████║   ██║   ██║  ██║███████╗
╚══════╝╚═╝  ╚═╝╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝╚══════╝
************************************************************************************************/



/*********************************************************************************************
*                                        MIT License                                         *
*--------------------------------------------------------------------------------------------*
* Copyright (c) 2025 erkan612                                                                *
*                                                                                            *
* Permission is hereby granted, free of charge, to any person obtaining a copy of this       *
* software and associated documentation files (the "Software"), to deal in the Software      *
* without restriction, including without limitation the rights to use, copy, modify, merge,  *
* publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons *
* to whom the Software is furnished to do so, subject to the following conditions:           *
*                                                                                            *
* The above copyright notice and this permission notice shall be included in all copies or   *
* substantial portions of the Software.                                                      *
*                                                                                            *
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,        *
* INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR   *
* PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE  *
* FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR       *
* OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER     *
* DEALINGS IN THE SOFTWARE.                                                                  *
**********************************************************************************************
*--------------------------------------------------------------------------------------------*
*   					***********************************************                      *
*   					  ███╗   ███╗ █████╗      ██╗ ██████═╗██████═╗	                     *
*   					  ████╗ ████║██╔══██╗     ██║██╔═══██║██╔══██║	                     *
*   					  ██╔████╔██║███████║     ██║██║   ██║██████╔╝	                     *
*   					  ██║╚██╔╝██║██╔══██║██   ██║██║   ██║██╔══██╗	                     *
*   					  ██║ ╚═╝ ██║██║  ██║╚█████╔╝╚██████╔╝██║  ██║	                     *
*   					  ╚═╝     ╚═╝╚═╝  ╚═╝ ╚════╝  ╚═════╝ ╚═╝  ╚═╝	                     *
*   					              ██████╗ ██╗   ██╗██╗	                                 *
*   					             ██╔════╝ ██║   ██║██║	                                 *
*   					             ██║  ███╗██║   ██║██║	                                 *
*   					             ██║   ██║██║   ██║██║	                                 *
*   					             ╚██████╔╝╚██████╔╝██║	                                 *
*   					              ╚═════╝  ╚═════╝ ╚═╝	                                 *
*   				   ██████╗ ██╗   ██╗██╗██╗     ██████╗ ███████╗██████╗ 	                 *
*   				   ██╔══██╗██║   ██║██║██║     ██╔══██╗██╔════╝██╔══██╗	                 *
*   				   ██████╔╝██║   ██║██║██║     ██║  ██║█████╗  ██████╔╝	                 *
*   				   ██╔══██╗██║   ██║██║██║     ██║  ██║██╔══╝  ██╔══██╗	                 *
*   				   ██████╔╝╚██████╔╝██║███████╗██████╔╝███████╗██║  ██║	                 *
*   				   ╚═════╝  ╚═════╝ ╚═╝╚══════╝╚═════╝ ╚══════╝╚═╝  ╚═╝	                 *
*   				         ⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⢠⣶⣶⣶⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀        				     *
*   				         ⠀⠀⠀⠀⠀⠀⢀⣴⣾⣿⣷⣄⢀⣸⣿⣿⣿⣿⣄⠀⣴⣿⣿⣶⣄⠀⠀⠀⠀⠀                              *
*   				         ⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇⠀⠀⠀⠀⠀                              *
*   				         ⠀⠀⢀⣴⣦⣤⣠⣾⣿⣿⣿⠟⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⣀⣤⣤⡄⠀                              *
*   				         ⠀⠀⣾⣿⣿⣿⣿⣿⣿⠟⠁⠀⠀⢙⣿⣿⣿⣿⣿⡿⠋⢹⣿⣿⣿⣿⣿⣿⣿⡆                              *
*   				         ⠀⠀⠉⠻⣿⣿⣿⡿⠁⠀⠀⠀⣴⣿⣿⣿⣿⣿⣿⠃⠀⠻⠿⠃⣿⣿⣿⣿⠋⠀                              *
*   				         ⣡⣀⣀⣼⣿⣿⣿⡇⠀⠀⣠⡟⠉⠙⢿⣿⣿⡿⠉⠀⢀⣨⣤⣴⣿⣿⣿⣿⣀⣀                              *
*   				         ⢸⣿⣿⣿⣿⣿⣿⣷⣠⣾⣿⣿⣦⡄⣠⡿⠃⠀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿                              *
*   				         ⠼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠁⠀⣠⡾⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿                              *
*   				         ⠀⠀⠀⢙⣿⣿⣿⣿⣿⠿⠿⠟⠁⠀⣠⣾⣧⡀⠀⠈⠻⣿⣿⣿⣿⣿⣿⡏⠀⠀        				     *
*   				         ⠀⠀⣵⣿⣿⣿⣿⣿⠁⣾⡀⠀⢠⣾⣿⣿⣿⣿⣦⡀⠀⠈⢻⣿⣿⣿⣿⣿⣶⡀                              *
*   				         ⠀⠀⢻⣿⣿⣿⣿⣿⣼⣿⡟⠀⣼⣿⣿⣿⣿⣿⣿⣿⣦⣤⣾⣿⣿⣿⣿⣿⣿⠃                              *
*   				         ⠀⠀⠀⠙⠉⠁⠈⣻⣿⣿⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠋⠀⠉⠙⠁⠀                              *
*   				         ⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⡿⢿⣿⣿⣿⣿⣿⣿⠿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀                              *
*   				         ⠀⠀⠀⠀⠀⠀⠀⠙⠻⢿⠏⠀⠀⢸⣿⣿⣿⣿⠀⠀⠘⠿⠿⠛⠁⠀⠀⠀⠀⠀                              *
*   				                                                                         *
*   						***************************************                          *
*********************************************************************************************/



#macro MAJOR_GUI_BUILDER_NAMESPACE globalvar MajorGUIBuilder; MajorGUIBuilder = new MajorGUIBuilder()



function MajorGUIBuilder() constructor {
	m_elementRegistry = ds_map_create();
	m_animations = ds_list_create();
    m_animationTime = 0;
	
	/// @function Free()
	function Free() {
		ds_map_destroy(m_elementRegistry);
		ds_list_destroy(m_animations);
	};
	
	/// @function ID(element_id) -> element
    function ID(element_id) {
        return ds_map_exists(m_elementRegistry, element_id) ? m_elementRegistry[? element_id] : noone;
    };
    
    /// @function HasID(element_id) -> bool
    function HasID(element_id) {
        return ds_map_exists(m_elementRegistry, element_id);
    };
    
    /// @function GetRegisteredIDs() -> array
    function GetRegisteredIDs() {
		return ds_map_keys_to_array(m_elementRegistry);
    };
    
    function __RegisterElement(element, element_id) {
        if (element_id != "" && element_id != undefined) {
            if (ds_map_exists(m_elementRegistry, element_id)) {
                return;
            }
            ds_map_add(m_elementRegistry, element_id, element);
            ElementSetProperty(element, element_id, "builder_id");
        }
    };
	
	/// @function BuildCanvas(config, parent, position, size, bCol) -> canvas
	function BuildCanvas(config, parent, position, size, bCol) {
		var canvas = MajorGUI.CanvasCreate(position, size, bCol, parent);
		
		__ProcessCanvasConfig(canvas, config);
		
		return canvas;
	};
	
	/// @function BuildPanel(config, parent, position, size, scrollbarWidth = 12) -> container/panel
	function BuildPanel(config, parent, position, size, scrollbarWidth = 12) {
		if (scrollbarWidth < 0) {
	        var panel = MajorGUI.PanelCreate(
	            position != undefined ? position : new Vector3(0, 0, 0),
	            new Vector2(5, 5),
	            false,
	            parent,
	            undefined,
	            size != undefined ? size : new Vector2(400, 300)
	        );
			
			__ProcessPanelConfig(panel, config);
			
			return panel;
		}
		else {
			var container = MajorGUI.CanvasCreate(
	            position != undefined ? position : new Vector3(0, 0, 0),
	            size != undefined ? size : new Vector2(400, 300),
	            new Vector4(0, 0, 0, 0),
	            parent
	        );
			
	        var panel = MajorGUI.PanelCreate(
	            new Vector3(0, 0, 0),
	            new Vector2(5, 5),
	            false,
	            container,
	            undefined,
	            size
	        );
			
	        __AddAutoScrollbars(container, panel, scrollbarWidth);
			
	        ElementSetProperty(container, panel, "contentPanel");
			
			__ProcessPanelConfig(panel, config);
			
			return container;
		}
	};
	
	/// @function GetPanelContent(container) -> panel
	function GetPanelContent(container) {
		return ElementGetProperty(container, "contentPanel");
	};
	
	function __AddAutoScrollbars(container, targetPanel, scrollbarWidth = 12) {
		var containerSize = MajorGUI.CanvasGetSize(container);
		
        var scrollbarV = MajorGUI.ScrollbarVerticalCreate(
            new Vector3(containerSize.x - scrollbarWidth, 0, 0),
            targetPanel,
            new Vector2(scrollbarWidth, containerSize.y - scrollbarWidth),
            container
        );
        
        var scrollbarH = MajorGUI.ScrollbarHorizontalCreate(
            new Vector3(0, containerSize.y - scrollbarWidth, 0),
            targetPanel,
            new Vector2(containerSize.x - scrollbarWidth, scrollbarWidth),
            container
        );
        
        MajorGUI.ScrollbarSetLerpFactor(scrollbarV, 0.1);
        MajorGUI.ScrollbarSetLerpFactor(scrollbarH, 0.1);
        
        ElementSetProperty(targetPanel, scrollbarV, "m_scrollbarVertical");
        ElementSetProperty(targetPanel, scrollbarH, "m_scrollbarHorizontal");
        ElementSetProperty(targetPanel, 2000, "m_scrollbarVerticalSteps");
        ElementSetProperty(targetPanel, 2000, "m_scrollbarHorizontalSteps");
        
        ElementSetProperty(container, scrollbarV, "scrollbarVertical");
        ElementSetProperty(container, scrollbarH, "scrollbarHorizontal");
	};
	
	function __ProcessPanelConfig(panel, config) {
        for (var i = 0; i < array_length(config); i++) {
            var item = config[i];
            if (is_array(item)) {
				var rowSettingTitle = undefined;
				var rowSettingPlacement = undefined;
				var rowSettingAutoFit = true;
				if (array_length(item) > 0 && is_struct(item[0]) && (variable_struct_exists(item[0], "title") || variable_struct_exists(item[0], "placement") || variable_struct_exists(item[0], "autoFit"))) {
					rowSettingTitle = variable_struct_exists(item[0], "title") ? variable_struct_get(item[0], "title") : undefined;
					rowSettingPlacement = variable_struct_exists(item[0], "placement") ? variable_struct_get(item[0], "placement") : undefined;
					rowSettingAutoFit = variable_struct_exists(item[0], "autoFit") ? variable_struct_get(item[0], "autoFit") : true;
				}
				__ProcessRow(panel, item, rowSettingTitle, rowSettingPlacement, rowSettingAutoFit);
            } else {
                __ProcessElement(panel, item);
            }
        }
	};
	
	function __ProcessCanvasConfig(canvas, config) {
        for (var i = 0; i < array_length(config); i++) {
            var item = config[i];
            __ProcessCanvasElement(canvas, item);
        }
	};
	
	function __ProcessRow(panel, row, title = undefined, placement = undefined, autoFit = true) {
        MajorGUI.PanelPush(panel, title, placement, autoFit);
        for (var j = 0; j < array_length(row); j++) {
            __CreateElement(panel, row[j]);
        }
        MajorGUI.PanelPop(panel);
	};
	
	function __ProcessElement(panel, element) {
        if (variable_struct_exists(element, "title") && variable_struct_exists(element, "inputs")) {
            __ProcessSection(panel, element);
        } else {
			MajorGUI.PanelPush(panel);
            __CreateElement(panel, element);
			MajorGUI.PanelPop(panel);
        }
	};
	
	function __ProcessCanvasElement(canvas, element) {
        __CreateElement(canvas, element);
	};
	
	function __ProcessSection(panel, section) {
        var title = variable_struct_get(section, "title");
        var autoFit = variable_struct_exists(section, "autoFit") ? variable_struct_get(section, "autoFit") : false;
        var placement = variable_struct_exists(section, "placement") ? variable_struct_get(section, "placement") : 1;
        
        MajorGUI.PanelPush(panel, title, placement, autoFit);
        
        if (variable_struct_exists(section, "inputs")) {
            var inputs = variable_struct_get(section, "inputs");
            for (var i = 0; i < array_length(inputs); i++) {
                var inputItem = inputs[i];
                if (is_array(inputItem)) {
                    __ProcessRow(panel, inputItem);
                } else {
                    __ProcessElement(panel, inputItem);
                }
            }
        }
        
        MajorGUI.PanelPop(panel);
	};
	
	function __CreateElement(panel, config) {
        var element = noone;
        var placement = variable_struct_exists(config, "placement") ? variable_struct_get(config, "placement") : 1;
        var autoFit = variable_struct_exists(config, "autoFit") ? variable_struct_get(config, "autoFit") : true;
        var align = variable_struct_exists(config, "align") ? variable_struct_get(config, "align") : new Align(ALIGN.LEFT, ALIGN.MIDDLE);
        var element_id = variable_struct_exists(config, "id") ? variable_struct_get(config, "id") : "";
		var position = variable_struct_exists(config, "position") ? variable_struct_get(config, "position") : new Vector3(0, 0, 0);
        
        // LABEL
        if (variable_struct_exists(config, "label")) {
            var font = variable_struct_exists(config, "font") ? variable_struct_get(config, "font") : -1;
            element = MajorGUI.LabelCreate(
                position,
                variable_struct_get(config, "label"),
                panel,
                variable_struct_exists(config, "width") ? variable_struct_get(config, "width") : 200,
                wrapped_text.dots,
                new Vector4(255, 255, 255, 255),
                font
            );
            ElementSetProperty(element, "label", "builder_type");
        }
        // BUTTON
        else if (variable_struct_exists(config, "button")) {
            var btnConfig = variable_struct_get(config, "button");
            var btnText = is_struct(btnConfig) ? (variable_struct_exists(btnConfig, "text") ? variable_struct_get(btnConfig, "text") : "Button") : btnConfig;
            var btnAction = variable_struct_exists(config, "action") ? variable_struct_get(config, "action") : function(btn) { };
            var btnSize = variable_struct_exists(config, "size") ? variable_struct_get(config, "size") : new Vector2(100, 30);
            
            element = MajorGUI.ButtonCreate(
                position,
                btnText,
                panel,
                btnAction,
                btnSize
            );
            ElementSetProperty(element, "button", "builder_type");
        }
        // CHECKBOX
        else if (variable_struct_exists(config, "checkbox")) {
            var cbConfig = variable_struct_get(config, "checkbox");
            var cbSize = variable_struct_exists(cbConfig, "size") ? variable_struct_get(cbConfig, "size") : new Vector2(16, 16);
            var cbAction = variable_struct_exists(cbConfig, "action") ? variable_struct_get(cbConfig, "action") : function(cb) { };
            
            element = MajorGUI.CheckboxCreate(
                position,
                panel,
                cbSize,
                cbAction
            );
            
            if (variable_struct_exists(cbConfig, "checked")) {
                MajorGUI.CheckboxSetCheck(element, variable_struct_get(cbConfig, "checked"));
            }
            ElementSetProperty(element, "checkbox", "builder_type");
        }
        // RADIOBOX
        else if (variable_struct_exists(config, "radiobox")) {
            var radioConfig = variable_struct_get(config, "radiobox");
            var radioSize = variable_struct_exists(radioConfig, "size") ? variable_struct_get(radioConfig, "size") : new Vector2(16, 16);
            var radioAction = variable_struct_exists(radioConfig, "action") ? variable_struct_get(radioConfig, "action") : function(radio) { };
            
            element = MajorGUI.RadioboxCreate(
                position,
                panel,
                radioSize,
                radioAction
            );
            ElementSetProperty(element, "radiobox", "builder_type");
        }
        // SLIDEBAR
        else if (variable_struct_exists(config, "slidebar")) {
            var slideConfig = variable_struct_get(config, "slidebar");
            var _min = variable_struct_exists(slideConfig, "min") ? variable_struct_get(slideConfig, "min") : 0;
            var _max = variable_struct_exists(slideConfig, "max") ? variable_struct_get(slideConfig, "max") : 100;
            var value = variable_struct_exists(slideConfig, "value") ? variable_struct_get(slideConfig, "value") : 50;
            var percentage = (value - _min) / (_max - _min);
            
            element = MajorGUI.SlidebarCreate(
                position,
                panel,
                _min, _max,
                percentage,
                variable_struct_exists(slideConfig, "length") ? variable_struct_get(slideConfig, "length") : 150,
                variable_struct_exists(slideConfig, "width") ? variable_struct_get(slideConfig, "width") : 20
            );
            ElementSetProperty(element, "slidebar", "builder_type");
        }
        // SLIDER
        else if (variable_struct_exists(config, "slider")) {
            var sliderConfig = variable_struct_get(config, "slider");
            var _min = variable_struct_exists(sliderConfig, "min") ? variable_struct_get(sliderConfig, "min") : 0;
            var _max = variable_struct_exists(sliderConfig, "max") ? variable_struct_get(sliderConfig, "max") : 100;
            var value = variable_struct_exists(sliderConfig, "value") ? variable_struct_get(sliderConfig, "value") : 50;
            var percentage = (value - _min) / (_max - _min);
            
            element = MajorGUI.SliderCreate(
                position,
                panel,
                _min, _max,
                percentage,
                variable_struct_exists(sliderConfig, "length") ? variable_struct_get(sliderConfig, "length") : 150,
                variable_struct_exists(sliderConfig, "width") ? variable_struct_get(sliderConfig, "width") : 8,
                variable_struct_exists(sliderConfig, "height") ? variable_struct_get(sliderConfig, "height") : 20
            );
            ElementSetProperty(element, "slider", "builder_type");
        }
        // TEXTBOX
        else if (variable_struct_exists(config, "textbox")) {
            var tbConfig = variable_struct_get(config, "textbox");
            element = MajorGUI.TextboxCreate(
                position,
                new Vector2(variable_struct_exists(tbConfig, "width") ? variable_struct_get(tbConfig, "width") : 200, 28),
                panel
            );
            
            if (variable_struct_exists(tbConfig, "text")) {
                MajorGUI.TextboxSetText(element, variable_struct_get(tbConfig, "text"));
            }
            if (variable_struct_exists(tbConfig, "placeholder")) {
                MajorGUI.TextboxSetGhostText(element, variable_struct_get(tbConfig, "placeholder"));
            }
            if (variable_struct_exists(tbConfig, "multiline")) {
                MajorGUI.TextboxSetMultiline(element, variable_struct_get(tbConfig, "multiline"));
            }
            if (variable_struct_exists(tbConfig, "password")) {
                MajorGUI.TextboxSetPassword(element, variable_struct_get(tbConfig, "password"));
            }
            ElementSetProperty(element, "textbox", "builder_type");
        }
        // COMBOBOX
        else if (variable_struct_exists(config, "combobox")) {
            var comboConfig = variable_struct_get(config, "combobox");
            element = MajorGUI.ComboboxCreate(
                position,
                variable_struct_exists(comboConfig, "placeholder") ? variable_struct_get(comboConfig, "placeholder") : "Select",
                panel,
                variable_struct_exists(comboConfig, "size") ? variable_struct_get(comboConfig, "size") : new Vector2(124, 24)
            );
            
            if (variable_struct_exists(comboConfig, "options")) {
                var options = variable_struct_get(comboConfig, "options");
                for (var i = 0; i < array_length(options); i++) {
                    MajorGUI.ComboboxPush(element, options[i]);
                }
            }
            ElementSetProperty(element, "combobox", "builder_type");
        }
        // COMBOSWITCH
        else if (variable_struct_exists(config, "comboswitch")) {
            var switchConfig = variable_struct_get(config, "comboswitch");
            element = MajorGUI.ComboswitchCreate(
                position,
                panel,
                variable_struct_exists(switchConfig, "action") ? variable_struct_get(switchConfig, "action") : function(state) { },
                variable_struct_exists(switchConfig, "width") ? variable_struct_get(switchConfig, "width") : 250,
                variable_struct_exists(switchConfig, "height") ? variable_struct_get(switchConfig, "height") : 30
            );
            
            if (variable_struct_exists(switchConfig, "options")) {
                var options = variable_struct_get(switchConfig, "options");
                for (var i = 0; i < array_length(options); i++) {
                    MajorGUI.ComboswitchPush(element, options[i]);
                }
            }
            ElementSetProperty(element, "comboswitch", "builder_type");
        }
        // SELECTABLE
        else if (variable_struct_exists(config, "selectable")) {
            var selConfig = variable_struct_get(config, "selectable");
            element = MajorGUI.SelectableCreate(
                position,
                variable_struct_exists(selConfig, "name") ? variable_struct_get(selConfig, "name") : "Selectable",
                panel,
                variable_struct_exists(selConfig, "size") ? variable_struct_get(selConfig, "size") : new Vector2(200, 30),
                variable_struct_exists(selConfig, "action") ? variable_struct_get(selConfig, "action") : function(sel) { }
            );
            
            if (variable_struct_exists(selConfig, "doubleClick")) {
                MajorGUI.SelectableSetDoubleClickAction(element, variable_struct_get(selConfig, "doubleClick"));
            }
            ElementSetProperty(element, "selectable", "builder_type");
        }
        // SPRITE
        else if (variable_struct_exists(config, "sprite")) {
            var spriteConfig = variable_struct_get(config, "sprite");
            element = MajorGUI.SpriteCreate(
                position,
                variable_struct_exists(spriteConfig, "sprite") ? variable_struct_get(spriteConfig, "sprite") : -1,
                variable_struct_exists(spriteConfig, "frame") ? variable_struct_get(spriteConfig, "frame") : 0,
                variable_struct_exists(spriteConfig, "speed") ? variable_struct_get(spriteConfig, "speed") : 0,
                panel,
                variable_struct_exists(spriteConfig, "action") ? variable_struct_get(spriteConfig, "action") : function(spr) { }
            );
            ElementSetProperty(element, "sprite", "builder_type");
        }
        // TABLE CHART
        else if (variable_struct_exists(config, "table")) {
            var tableConfig = variable_struct_get(config, "table");
            element = MajorGUI.TableChartCreate(
                position,
                variable_struct_exists(tableConfig, "size") ? variable_struct_get(tableConfig, "size") : new Vector2(400, 200),
                variable_struct_exists(tableConfig, "headers") ? variable_struct_get(tableConfig, "headers") : [["Header", 1]],
                variable_struct_exists(tableConfig, "data") ? variable_struct_get(tableConfig, "data") : [["Data", "Value"]],
                panel
            );
            ElementSetProperty(element, "table", "builder_type");
        }
        // TREE VIEW
        else if (variable_struct_exists(config, "treeview")) {
            var treeConfig = variable_struct_get(config, "treeview");
            element = MajorGUI.TreeViewCreate(
                position,
                variable_struct_exists(treeConfig, "size") ? variable_struct_get(treeConfig, "size") : new Vector2(256, 300),
                panel
            );
            
            if (variable_struct_exists(treeConfig, "structure")) {
                __BuildTreeStructure(element, variable_struct_get(treeConfig, "structure"));
            }
            ElementSetProperty(element, "treeview", "builder_type");
        }
        // CANVAS
        else if (variable_struct_exists(config, "canvas")) {
            var canvasConfig = variable_struct_get(config, "canvas");
            element = MajorGUI.CanvasCreate(
                position,
                variable_struct_exists(canvasConfig, "size") ? variable_struct_get(canvasConfig, "size") : new Vector2(100, 100),
                variable_struct_exists(canvasConfig, "color") ? variable_struct_get(canvasConfig, "color") : new Vector4(255, 255, 255, 255),
                panel
            );
            
            if (variable_struct_exists(canvasConfig, "draw")) {
                MajorGUI.CanvasSetAfterDraw(element, variable_struct_get(canvasConfig, "draw"));
            }
            ElementSetProperty(element, "canvas", "builder_type");
        }
		// PANEL (Nested panel)
		else if (variable_struct_exists(config, "panel")) {
		    var panelConfig = variable_struct_get(config, "panel");
		    var panelSize = variable_struct_exists(config, "size") ? variable_struct_get(config, "size") : new Vector2(300, 200);
    
		    element = BuildPanel(
		        panelConfig,
		        panel,
		        position,
		        panelSize
		    );
		}
        
        if (element != noone) {
			if (ds_map_exists(panel, "pushWidth")) {
				MajorGUI.PanelElementCreate(panel, element, placement, autoFit, align);
			};
            
            __RegisterElement(element, element_id);
        }
        
        return element;
	};
	
	function __BuildTreeStructure(treeView, structure) {
        for (var i = 0; i < array_length(structure); i++) {
            var node = structure[i];
            if (variable_struct_exists(node, "parent")) {
                MajorGUI.TreeViewPushParentNode(treeView, variable_struct_get(node, "parent"));
                if (variable_struct_exists(node, "children")) {
                    var children = variable_struct_get(node, "children");
                    for (var j = 0; j < array_length(children); j++) {
                        if (is_struct(children[j]) && variable_struct_exists(children[j], "parent")) {
                            __BuildTreeStructure(treeView, [children[j]]);
                        } else {
                            MajorGUI.TreeViewAddChildNode(treeView, children[j]);
                        }
                    }
                }
                MajorGUI.TreeViewPopParentNode(treeView);
            } else {
                MajorGUI.TreeViewAddChildNode(treeView, node);
            }
        }
	};
	
	/// @function AnimationGet(element_id) -> animation
	function AnimationGet(element_id) {
		for (var i = 0; i < ds_list_size(m_animations); i++) {
			var animation = m_animations[| i];
			if (animation[? "element_id"] == element_id) {
				return animation;
			};
		};
		
		return undefined;
	};
	
	/// @function AnimateElement(element_id, animationConfig) -> undefined
    function AnimateElement(element_id, animationConfig) {
        var element = ID(element_id);
        if (element == noone) return;
        
        var animation = ds_map_create();
        ds_map_add(animation, "element", element);
        ds_map_add(animation, "element_id", element_id);
        ds_map_add(animation, "type", variable_struct_exists(animationConfig, "type") ? animationConfig.type : "move");
        ds_map_add(animation, "duration", variable_struct_exists(animationConfig, "duration") ? animationConfig.duration : 1.0);
        ds_map_add(animation, "startTime", m_animationTime);
        ds_map_add(animation, "config", animationConfig);
        
        // Store initial state
        ds_map_add(animation, "initialPosition", MajorGUI.CanvasGetPosition(element));
        ds_map_add(animation, "initialSize", MajorGUI.CanvasGetSize(element));
        
        ds_list_add(m_animations, animation);
    };
    
    /// @function UpdateAnimations() -> undefined
    function UpdateAnimations() {
        m_animationTime += delta_time / 1000000;
        
        for (var i = ds_list_size(m_animations) - 1; i >= 0; i--) {
            var animation = m_animations[| i];
            var elapsed = m_animationTime - animation[? "startTime"];
            var progress = min(elapsed / animation[? "duration"], 1.0);
            
            if (progress >= 1.0) {
                __CompleteAnimation(animation, i);
            } else {
                __UpdateAnimation(animation, progress);
            }
        }
    };
    
    function __UpdateAnimation(animation, progress) {
        var element = animation[? "element"];
        var config = animation[? "config"];
        var initialPos = animation[? "initialPosition"];
        
        switch (animation[? "type"]) {
            case "move":
                var targetPos = config[? "position"] != undefined ? config[? "position"] : initialPos;
                var currentPos = new Vector3(
                    lerp(initialPos.x, targetPos.x, progress),
                    lerp(initialPos.y, targetPos.y, progress),
                    initialPos.z
                );
                MajorGUI.CanvasSetPosition(element, currentPos);
                break;
                
            case "scale":
                var initialSize = animation[? "initialSize"];
                var targetScale = config[? "scale"] != undefined ? config[? "scale"] : 1.0;
                var currentScale = lerp(1.0, targetScale, progress);
                MajorGUI.CanvasSetSize(element, new Vector2(initialSize.x * currentScale, initialSize.y * currentScale));
                break;
                
            case "shake":
                var intensity = variable_struct_exists(config, "intensity") ? config.intensity : 5;
                var shakeX = random_range(-intensity, intensity) * (1 - progress);
                var shakeY = random_range(-intensity, intensity) * (1 - progress);
                MajorGUI.CanvasSetPosition(element, new Vector3(initialPos.x + shakeX, initialPos.y + shakeY, initialPos.z));
                break;
        }
    };
    
    function __CompleteAnimation(animation, index) {
        var element = animation[? "element"];
        var config = animation[? "config"];
        
        switch (animation[? "type"]) {
            case "move":
                MajorGUI.CanvasSetPosition(element, config[? "position"]);
                break;
        }
        
        if (variable_struct_exists(config, "onComplete")) {
            config.onComplete(element);
        }
        
        ds_list_delete(m_animations, index);
        ds_map_destroy(animation);
    };
};
