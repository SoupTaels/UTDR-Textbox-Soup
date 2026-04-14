/// @func UndoableMove()
/// @desc Constructor for an undoable move, gathering one or more undoable changes.
function UndoableMove() constructor {
    changes = [];
    undone = false;
    
    /// @func is_empty()
    /// @desc Checks if the move has no changes.
    /// @returns {Bool}
    static is_empty = function() {
        return array_length(changes) == 0;
    }
    
    /// @func apply_change(change)
    /// @desc Tries applying the given change, if possible.
    /// @param {Struct.UndoableChange} change
    /// @returns {Bool}
    static apply_change = function(change) {
        if (undone)
            throw "Cannot apply a change on a move that has already been undone.";
        
        if (!change.can_apply())
            return false;
        
        change.apply();
        array_push(changes, change);
        return true;
    }
    
    /// @func undo()
    /// @desc Undoes all the changes made during the move.
    /// @returns {Undefined}
    static undo = function() {
        if (undone)
            throw "Cannot undo a move that has already been undone.";
        
        undone = true;
        var changes_count = array_length(changes);
        for (var i = changes_count - 1; i >= 0; i--) {
            changes[i].undo();
        }
    }
    
    /// @func redo()
    /// @desc Redoes all the changes made during the move.
    /// @returns {Undefined}
    static redo = function() {
        if (!undone)
            throw "Cannot redo a move that hasn't been undone.";
        
        undone = false;
        var changes_count = array_length(changes);
        for (var i = 0; i < changes_count; i++) {
            changes[i].apply();
        }
    }
    
    /// @func cleanup()
    /// @desc Frees the manually managed memory associated with the move changes.
    /// @returns {Undefined}
    static cleanup = function() {
        var changes_count = array_length(changes);
        for (var i = 0; i < changes_count; i++) {
            changes[i].cleanup();
        }
    }
}
