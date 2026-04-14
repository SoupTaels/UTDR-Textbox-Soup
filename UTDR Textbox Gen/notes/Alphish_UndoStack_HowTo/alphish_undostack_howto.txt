General concepts
================

The Undo Stack library allows setting up the undo/redo actions for your game/program.
It keeps track of **moves** consisting of one or more **changes** to the **core game state**.
The moves are organised into the **undo stack**.

The **core game state** relates to things like elements positions, health and mana variables etc.
Variables related to presentation (sprite images, tweens, etc.) don't need to be controlled by the undoable changes,
as long as the presentation can be re-synchronised with the core game state (recalculating sprite images, instances cancelling their tweens and going back to old positions etc.).
For the undo functionality to work properly, *every single change to the core game state should be performed via a corresponding undoable change!*

An **undoable change** is a simple change of the core game state, that can be either applied or undone.
Undoing a change must restore the core game state to how it was before the change was applied.
E.g. if a change adds 1 to health, undoing should subtract 1 from health.
If a change replaces a digit 2 with 7, undoing the change should replace the 7 back with 2.

An **undoable move** is a set of one or more changes, usually related to a single input or a quick sequence of inputs.
For example, when the player moves right, they can apply a simple "character X increases by 1" change.
Or if there's a pushable block to the right, the move would consist of "block X increases by 1" and "character X increases by 1" changes.
Likewise, if the user types lots of characters with less than 500ms gap between continuous characters,
it would produce a series of text input changes ("type L", "type o", "type r" etc.) undoable as a single move.

The **undo stack** keeps track of the performed moves (which can be undone) as well as undone moves (which can be redone).
When the user performs the "undo" command, it will undo all the changes in the most recently performed move.
When the user performs the "redo" command, it will once again apply all the changes in the the most recently undone move.
If the user applies any change after undoing some moves, all the undone moves are gone and cannot be redone.

Basic use
=========

To setup the Undo Stack system, you first need to create an instance of the undo stack controller. It can be done using `undo_stack_create()` function.
Usually, this function would be called when the room is created, or when level is loaded etc.
Note: There can be only one instance of undo stack controller at a time! Make sure that no controller instance exists when calling `undo_stack_create()`.

In order for the other `undo_stack_*` functions to work, an instance of the undo stack controller must be created first.

To complete the current move and begin the next one, use `undo_stack_begin_move()` or `undo_stack_complete_move()` function.
These functions are equivalent; using either version boils down to developer preference and whether the surrounding code feels more like "completion" or "beginning".
If the current move has no changes, these functions won't have any effect - no point adding a new move if the current one doesn't have changes to potentially undo, after all.

To apply an undoable change, use `undo_stack_apply_change(change)` function, passing an undoable change struct as the argument.
It will determine whether the change is applicable in the first place, and if so, apply the change and add it to the current undoable move.
The undoable changes passed to the function should be derived from UndoableChange struct. See "Implementing undoable changes" section for more details.
*Note: The changes should only be applied via the `undo_stack_apply_change(...)` function, rather than a direct `some_change.apply()` call.*
*Note: Applying a new change will cause all redoable moves to be forgotten.*

To undo the most recent move, call the `undo_stack_undo()` function.
To undo all the performed moves so far, call the `undo_stack_undo_all()` function.
To redo the most recently undone move, call the `undo_stack_redo()` function.
To redo all the available redoable moves, call the `undo_stack_redo_all()` function.

You can also set the size of the undo stack using the `undo_stack_set_max_size(size)` function.
This will change the maximum number of non-empty undoable moves stored at a time and remove any excess moves.
If the given size is 0 or less, the stack will store an unlimited number of moves (as long as there's enough memory to store all these).
The stack size is unlimited by default.

Once you no longer need the undo stack, call the `undo_stack_destroy()` function.
Alternatively, you can let the undo stack controller instance be automatically destroyed when moving between rooms.
Obviously, when the undo stack controller is destroyed, all the data about moves performed/undone becomes lost.

Implementing undoable changes
-----------------------------

When implementing an undoable change, you should:

- define a constructor function inheriting from UndoableChange struct
- override the `apply()` method with the core game state change
- override the `undo()` method which reverts the core game state change

Additionally, you can override the `can_apply()` method to decide when a change is applicable.
The typical use case would be preventing pointless changes that don't really change the state (e.g. the old and new variable values are the same).

Finally, you can override the `cleanup()` method to free the manually managed memory associated with the given change.
For example, if the change struct creates its own ds_list, it needs to destroy it in the `cleanup()` method to prevent a memory leak.
*Note: This only applies to structures owned by the change struct. If the struct receives a shared ds_list from the outside, it shouldn't destroy the list!*

An example undoable change implementation:

    function TestVariableChange(value) : UndoableChange() constructor {
        new_value = value;
        previous_value = global.test_variable;
        some_ds_list = ds_list_create();
        
        static can_apply = function() {
            return new_value != previous_value;
        }
    
        static apply = function() {
            global.test_variable = new_value;
        }
    
        static undo = function() {
            global.test_variable = previous_value;
        }
        
        static cleanup = function() {
            ds_list_destroy(some_ds_list);
        }
    }

Functions reference
-------------------

- `undo_stack_create()` - creates a new instance of the undo stack controller object, necessary for the other undo_stack_* functions
- `undo_stack_destroy()` - destroys the instance of the undo stack controller object when it's no longer needed
- `undo_stack_begin_move()` / `undo_stack_complete_move()` - completes the changes of the previous move and marks the start of the new undoable move
- `undo_stack_apply_change(change)` - performs a given undoable change as given by the change struct; the change struct should be derived from UndoableChange
- `undo_stack_undo()` - undoes the most recently performed move
- `undo_stack_undo_all()` - undoes all the performed moves so far
- `undo_stack_redo()` - redoes the most recently undone move
- `undo_stack_redo_all()` - redoes all the available redoable moves
- `undo_stack_set_max_moves(size)` - changes the number of maximum remembered undoable moves; if set to 0 or less, removes the moves limit

Codebase
========

Core functions
--------------

The package defines several undo_stack_* functions, defined in the **Packages >> Alphish >> Undo Stack* folder, in the **funcs_UndoStack** script.
The functions are listed in the "Functions reference" section. You might have read this section just recently.

Utilities
---------

The package uses two utility functions defined in the **Packages >> Alphish >> Common** folder:

- `instance_single(object)` ensures there's exactly one instance of the given object and returns it; it replaces the bug-prone `obj_SomeObject.some_variable` syntax
- `not_implemented_exception()` returns an exception message for a given method not being implemented/overriden

*At some point I might create the actual "Common" package with various utility functions. Such a package would include both of these functions as well.*

Structs
-------

The package defines a few structs, outlined below.

**UndoableChange** is intended as a base struct for changes. It defines overrideable methods `can_apply()`, `apply()`, `undo()` and `cleanup()`.
Outside the Undo Stack package, the UndoableChange struct should only be used as a base for specific changes.
The UndoableChange struct should never be created and used directly, especially with its not-implemented methods `apply()` and `undo()` throwing a corresponding exception.

**UndoableMove** represents a move consisting of one or more changes. It defines methods for applying a new change, undoing all its changes and redoing them.
Generally, it shouldn't be used directly outside of the Undo Stack package; it's UndoStack's responsibility to create and manage its moves.

**UndoStack** stores the actual undo/redo stacks. It defines methods for beginning new moves, applying changes, performing undo/redo operations and cleaning up.
For simple use cases, it shouldn't be used directly outside of the Undo Stack package; instead, its functionality is exposed via the `undo_stack_*` functions.
A user may want to directly create and manage UndoStack instances in more complex scenarios, e.g. handling multiple parallel undo/redo stacks.

Objects
-------

The package defines a **ctrl_UndoStack** object. It simply defines its own UndoStack struct instance and exposes it to the `undo_stack_*` functions.
When destroyed, it cleans up the inner undo stack to free any manually managed memory associated with the undone changes.

The ctrl_UndoStack object shouldn't be created or destroyed directly - instead, you should use `undo_stack_create()` and `undo_stack_destroy()` operations.
Likewise, the user shouldn't need to access the inner UndoStack instance; instead, it should be fully manageable via `undo_stack_*` functions. 
