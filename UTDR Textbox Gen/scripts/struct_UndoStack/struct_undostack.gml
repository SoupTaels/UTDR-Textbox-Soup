/// @func UndoStack()
/// @desc Constructor for the undo stack manager.
function UndoStack() constructor {
    moves = [];
    undone_moves = [];
    max_size = 0;
    begin_move();
    
    /// @func is_empty()
    /// @desc Checks whether the undo stack is empty.
    /// @returns {Bool}
    static is_empty = function() {
        return array_length(moves) == 0;
    }
    
    /// @func begin_move()
    /// @desc Begins a new undoable move.
    /// @returns {Undefined}
    static begin_move = function() {
        if (!is_empty() && get_last_move().is_empty())
            return;
        
        array_push(moves, new UndoableMove());
    }
    
    /// @func apply_change(change)
    /// @desc Tries to apply a given undoable change. The change will clear the redo stack.
    /// @param {Struct.UndoableChange} change
    /// @returns {Undefined}
    static apply_change = function(change) {
        var last_move = get_last_move();
        var is_first_move_change = last_move.is_empty();
        var change_applied = last_move.apply_change(change);
        if (!change_applied)
            return;
        
        discard_redoable_moves();
        if (is_first_move_change)
            discard_excess_moves();
    }
    
    /// @func undo_move()
    /// @desc Undoes the last non-empty move, if any.
    /// @returns {Undefined}
    static undo_move = function() {
        if (get_last_move().is_empty())
            array_pop(moves);
        
        if (array_length(moves) > 0) {
            var undone_move = array_pop(moves);
            undone_move.undo();
            array_push(undone_moves, undone_move);
        }
        
        begin_move();
    }
    
    /// @func undo_all()
    /// @desc Undoes all of the moves so far.
    /// @returns {Undefined}
    static undo_all = function() {
        if (get_last_move().is_empty())
            array_pop(moves);
        
        var moves_count = array_length(moves);
        repeat (moves_count) {
            var undone_move = array_pop(moves);
            undone_move.undo();
            array_push(undone_moves, undone_move);
        }
        
        begin_move();
    }
    
    /// @func redo_move()
    /// @desc Redoes the last undone move, if not overwritten.
    /// @returns {Undefined}
    static redo_move = function() {
        if (array_length(undone_moves) == 0)
            return;
        
        if (get_last_move().is_empty())
            array_pop(moves);
        
        if (array_length(undone_moves) > 0) {
            var redone_move = array_pop(undone_moves);
            redone_move.redo();
            array_push(moves, redone_move);
        }
        
        begin_move();
    }
    
    /// @func redo_all()
    /// @desc Redoes all of the undone moves that weren't overwritten.
    /// @returns {Undefined}
    static redo_all = function() {
        if (get_last_move().is_empty())
            array_pop(moves);
        
        var moves_count = array_length(undone_moves);
        repeat (moves_count) {
            var redone_move = array_pop(undone_moves);
            redone_move.redo();
            array_push(moves, redone_move);
        }
        
        begin_move();
    }
    
    /// @func set_max_size(size)
    /// @desc Sets the maximum number of remembered undoable moves.
    /// If the number is 0 or less, the number of moves is unlimited.
    /// @param {Real} size
    /// @returns {Undefined}
    static set_max_size = function(size) {
        max_size = size;
        discard_excess_moves();
    }
    
    /// @func cleanup()
    /// @desc Frees the manually managed memory associated with the moves in the stack.
    /// @returns {Undefined}
    static cleanup = function() {
        cleanup_moves_array(moves);
        cleanup_moves_array(undone_moves);
    }
    
    /// @ignore
    /// Internal: Gets the current undoable move.
    static get_last_move = function() {
        return moves[array_length(moves) - 1];
    }
    
    /// @ignore
    /// Internal: Discards moves that go beyond the max moves limit.
    static discard_excess_moves = function() {
        if (max_size <= 0)
            return;
        
        var moves_count = array_length(moves);
        if (moves[moves_count - 1].is_empty())
            moves_count--;
        
        var discarded_count = moves_count - max_size;
        if (discarded_count <= 0)
            return;
        
        for (var i = 0; i < discarded_count; i++) {
            moves[i].cleanup();
        }
        array_delete(moves, 0, discarded_count);
    }
    
    /// @ignore
    /// Internal: Discards all the undone moves.
    static discard_redoable_moves = function() {
        cleanup_moves_array(undone_moves);
        undone_moves = [];
    }
    
    /// @ignore
    /// Internal: frees the memory associated with the given moves.
    static cleanup_moves_array = function(moves_array) {
        var moves_count = array_length(moves_array);
        for (var i = 0; i < moves_count; i++) {
            moves_array[i].cleanup();
        }
    }
}
